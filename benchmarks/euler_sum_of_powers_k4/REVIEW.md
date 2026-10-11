# Independent Euler K4 implementation and execution review

Author: STARGA Inc.

Publication disclosure: review was performed by an AI agent assigned separately
from implementation. It was not external human validation. Any approval still
follows the public PROOF_POLICY.md.
Date: 2026-10-11 UTC

Scope: independent source review, arithmetic bounds, parsing, certificate binding,
logical inference boundary, mutation discrimination, and reruns of the final
native executables. This is not designated-verifier theorem acceptance, a
compiler correctness proof, an independent-machine run, or an RH progress claim.

## Reviewed inputs and policy

Read GOVERNANCE.md, AUTHORSHIP.md, PROOF_POLICY.md, CONTRIBUTING.md, toolchain
documentation, the benchmark README, both test contracts, TEST_ADJUSTMENTS.md,
checker and harness sources, certificate fixtures, four source mutation diffs,
and build/run receipts. The result remains FORMALIZATION_BLOCKED; the repository
has no validated native proof calculus or authorized NATIVE_VERIFIED transition.

Final reviewed source SHA-256 values:

| Source | SHA-256 |
| --- | --- |
| src/checker.mind | 151c4dad01b6ef5e00620d199fc8b0b64f3bdd197ed3468e1b6ee8819cbe0faa |
| src/main.mind | 1fca86e6b11316b7aa277f314e50f1b9ae8a0154a2acc5b6a7692b639f06d11a |
| supplemental/main.mind | 8f3bae8c611ef00f1d49260e8e9a2bad2a57d0862c05e919c5da7e678f683294 |
| TEST_CONTRACT.md | 03a5825aee197064f8c65332463502a55c1ff9976edd3f0bc161db23363f5e61 |
| MUTATION_CONTRACT.md | 0128eb027debf5965a2df828baaf26e5bc7df372d4d47c8596bcd31a797a6c3b |

The four certificate hashes match the downloaded preparation fixtures; their
lengths are 225, 388, 146 and 369 bytes. The checker and original 1,240-case
contract are unchanged. The two main-harness offset corrections implement the
already-declared test, rather than changing the test count or expected result.

The installed compiler executable was independently hashed and matches
toolchain/compiler.sha256:
a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa.
The successful build receipts explicitly use its MLIR CPU backend. Native
execution here means the generated native ELF, not qualification of the
compiler's distinct native backend. Complete compiler/runtime provenance and
compiler soundness are not established by matching this hash.

## Arithmetic and parsing assessment

For 0 < x <= 999999, multiplication maintains 0 <= limb <= 999 and
0 <= carry < x. Thus limb*x+carry <= 999998999, safely within signed i64.
For x=0, all resulting limbs and carries are zero. Addition maintains carry
at most one and computes values at most 1999. Each fourth power is below
10^24, while the sum of three is below 3*10^24; twelve base-1000 limbs provide
capacity below 10^36. Both arithmetic operations check the outgoing carry.
Computed powers, all claimed limbs including high zeros, the computed sum,
and the fourth witness power are compared.

The parser checks decimal bounds before multiplication, rejects signs and
leading zeros, requires LF termination, and rejects trailing content. The
documented entry points bound input length by 4096 bytes; allocated input
buffers hold 4097 bytes, including the overflow-read/trailing-byte slot. The
32-byte witness and 224-byte scratch layouts fit their accesses. Literal and
number parsing preserve cursor bounds under the compiler's ordinary i64 and
short-circuit semantics and the documented caller-owned-buffer assumptions.

Refutation checking recomputes arithmetic, requires all four positive witnesses
to equal the arithmetic tuple, and recognizes exactly the supported statement
and six-step derivation text. The bounded executable witness domain supplies
a candidate counterexample; it does not change C4's quantification over Z.

## Findings resolved during review

1. The arithmetic header occupies 18 bytes. The original offset 21 changed
   95800 to 95810, while the declared test said 95801. The initial supplemental
   coherent-pair probe therefore paired 95810 with 95801 and incorrectly hid
   the recomputation mutant's second expected false acceptance. Review identified
   the mismatch and independently reproduced its correction in an isolated
   scratch build. Final offsets use 22, and the complete campaign was repeated.
2. The original harness can miss removed power recomputation because its only
   well-formed changed arithmetic witness is later rejected by tuple binding.
   The supplementary direct-arithmetic and coherent-pair probes expose this
   fault without weakening or replacing the frozen 1,240-case contract.
3. The strict carry<x explanation needed a separate x=0 case. Documentation now
   states that case; the production arithmetic code required no correction.

TEST_ADJUSTMENTS.md describes these changes. The retained initial campaign and
three failed infrastructure attempts must not be presented as successful
mutation discrimination or native builds.

## Independent execution

Independently reran the final baseline harness, baseline probe and all four
mutant probes. Each used the original four certificate streams and this command
shape from the benchmark directory:

```sh
/usr/bin/time -v -o "$receipt.time.txt" \
  timeout 15 taskset -c 0 nice -n 19 \
  prlimit --as=268435456 --cpu=10 -- "$executable" \
  < arithmetic.txt 3< refutation.txt \
  4< zero-arithmetic.txt 5< zero-refutation.txt \
  > "$receipt.stdout" 2> "$receipt.stderr"
```

All six stdout, stderr and exit-code receipts match the corresponding final
campaign receipts byte for byte. Every stderr is empty. Maximum resident memory
across these reruns was 8156 KiB. The raw independent receipts and executable
hashes accompany this review in evidence/independent-review/.

The original harness exits 0 with ARITHMETIC_CERTIFICATE=PASS,
REFUTATION_TEMPLATE=PASS, NEGATIVE_CASES_EXECUTED=1240 and FINITE_TESTS=PASS.
Its count equals 2+225+388+1+4+1+4+225+388+2. The supplemental baseline exits 0
with six zero invalid-acceptance observations and successful positive and
restoration controls.

Acceptance-vector order is: positivity, direct arithmetic, coherent false
equality, tuple mismatch, arithmetic trailing LF, refutation trailing LF.

| Variant | Acceptance vector | Probe exit | Positive/restoration controls |
| --- | --- | ---: | --- |
| Baseline | 000000 | 0 | PASS |
| Positivity removed | 100000 | 1 | PASS |
| Recomputation removed | 011000 | 1 | PASS |
| Tuple binding removed | 000100 | 1 | PASS |
| End-of-input comparison removed | 000011 | 1 | PASS |

Each mutant demonstrates the intended actual false acceptance. These are normal
completed executions; crashes, timeouts and failed builds do not explain the
results. The recomputation mutant fills all twelve claimed limbs before using
them, retains decimal bounds and sum/equality checks, and does not depend on
uninitialized memory. The EOF mutant retains parser-failure checking.

Reviewed final build receipts show all ten harness/probe variants built with
exit 0 and empty stderr. The original harness rejected positivity, binding and
EOF mutants with exit 1, but the recomputation mutant survived all 1,240 tests
with exit 0. That survival is real and explicitly reported; the supplementary
probe is what detects it. These four original-mutant results were reviewed
from raw campaign receipts, rather than independently rerun in this review.

The final source hashes in all ten isolated build projects match the reviewed
baseline sources and mutation-specific checker hashes. All ten native ELF
hashes agree with evidence/executables.sha256. This ties the checked outputs to
identified artifacts without claiming an independently bootstrapped toolchain.

## Logical boundary and remaining obligations

The intended six-step mathematical argument is appropriate: exact numeral
evaluation establishes positivity and equality; assuming C4, universal and
implication elimination give the negation of that equality; contradiction
followed by discharge yields not(C4). No excluded middle is required.

The executable validates a fixed derivation template. It has no general proof
parser, independently validated inference calculus, accepted arithmetic bridge,
axiom/dependency closure, or designated-verifier acceptance. Passing this review
does not satisfy those outstanding proof-policy requirements. Keep formal
acceptance BLOCKED and distinguish arithmetic checking, template checking and
accepted formal proof. No RH status or progress changes follow.

No remaining implementation defect was found in the reviewed scope. Repository
governance execution, final documentation integration, commit metadata, private
branch push and draft PR completion remain the integrating agent's separate
deliverables; this review does not certify actions that had not yet occurred.

VERDICT: PASS
