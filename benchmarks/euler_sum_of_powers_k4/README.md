# EULER_SUM_OF_POWERS_K4_COUNTEREXAMPLE

Author: STARGA Inc.

Early benchmark candidate separating a concrete exact arithmetic identity from
its use in refuting a quantified proposition. No RH result is asserted.

## Statement and two certificates

Let C4 be `forall a,b,c,d : Z, (a>0 and b>0 and c>0 and d>0) ->
not(a^4+b^4+c^4=d^4)`. The intended result is `not(C4)`, with the tuple
`(95800,217519,414560,422481)`. The mathematical quantifiers range over all
integers; the executable's bounded witness input does not redefine C4.

1. `arithmetic.txt` supplies the tuple, four fourth powers and the left-side sum.
   Each large value is exactly twelve little-endian base-1000 limbs. The checker
   recomputes every power and sum and compares every limb, including leading zero
   limbs. It accepts no claimed equality or PASS flag without recomputation.
2. `refutation.txt` separately supplies the full C4 statement, the same tuple,
   domain obligations and a six-step natural-deduction refutation candidate.
   The experimental recognizer reruns arithmetic, checks tuple identity and
   positivity, and requires the exact supported derivation template. It rejects
   changed exponents, domains, rules, references, assumptions and conclusions.

The template recognizer is deliberately narrow. It is NOT a general proof
parser, validated logic kernel, or authorization to accept a theorem. Successful
execution may report `REFUTATION_TEMPLATE=PASS`, never native proof acceptance.

## Exact arithmetic scope and bounds

Supported certificate witnesses are 0 through 999999. Zero is valid arithmetic
input and is rejected only by the positive-integer refutation stage. Values
outside this executable's domain are rejected, not truncated. This is a checked
bounded multi-limb implementation, not a general arbitrary-precision library.
It suffices for this witness without weakening the integer identity.

Twelve base-1000 limbs represent values below 10^36. Each fourth power here is
below 10^24, and a sum of three is below 3*10^24. Small multiplication uses
`t = limb*x + carry`; for positive x, induction gives `limb <= 999` and
`carry < x`, so `t < 1000*x <= 999999000`, well within signed i64. For x=0,
each multiplication produces zero limbs and zero carry. For addition, `t <= 1999`.
Every outgoing carry is checked. Parsing checks the bound BEFORE multiplying
by ten and rejects signs, leading zeros, missing LF and trailing content.

The exact values supplied in the certificate are:

| Expression | Integer |
| --- | --- |
| 95800^4 | 84229075969600000000 |
| 217519^4 | 2238663363846304960321 |
| 414560^4 | 29535857400192040960000 |
| 422481^4 and the sum | 31858749840007945920321 |

## Formal rule obligations

The intended object logic has integers, exact natural-number powers, conjunction,
implication, universal quantification, falsehood and negation `not(P) = P -> false`.
Step 1 establishes integer membership and the four strict inequalities by numeral
evaluation. Step 2 is the arithmetic equality. Under the sole local assumption C4
(step 3), universal elimination at these numerals followed by implication
elimination with step 1 produces the negated equality (step 4). Applying that
negation to step 2 gives false (step 5). Implication/negation introduction
discharges exactly step 3 and yields not(C4) (step 6). No excluded middle or
assumption of C4 outside this discharged subproof is needed.

Native acceptance remains blocked pending reviewed semantics for numeral
evaluation and the arithmetic bridge, validated inference rules and dependency
closure, native execution with the pinned compiler, independent review, and the
owner/designated verifier's acceptance under PROOF_POLICY.md. A prose soundness
argument plus a matching template is not a substitute for those obligations.

## Reproduce on the pinned native environment

From the repository root, verify the compiler, build, then run all fixtures:

```bash
set -euo pipefail
compiler=$(readlink -f "$(command -v mindc)")
test "$(sha256sum "$compiler" | cut -d ' ' -f1)" = "$(cat toolchain/compiler.sha256)"
cd benchmarks/euler_sum_of_powers_k4
sha256sum -c SHA256SUMS
MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt \
MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate \
CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang \
mindc build src/main.mind --backend mlir --target cpu --emit binary \
  --optimize debug --no-cache --out /tmp/euler-k4-check
(ulimit -t 10; ulimit -v 262144; timeout 15 /tmp/euler-k4-check < arithmetic.txt 3< refutation.txt 4< zero-arithmetic.txt 5< zero-refutation.txt)
```

Keep compiler/backend provenance, build stdout/stderr/exit, executable hash, run
stdout/stderr/exit and independent review with the exact source/certificate hashes.
The historical development campaign also ran its own governance gate; that
unrelated gate is not a dependency of this public extraction.

## Evidence and provenance

Prepared against `the internal development repository` main commit
`45a5492067f902c39851f11fc678060d7824c017` on 2026-10-11 UTC.
The user supplied the tuple and proposed benchmark in this conversation. The
integer values and derivation are mathematical data; no third-party implementation
or confidential research input was copied. Historical attribution and dates from
the screenshot are not relied upon or asserted by this benchmark.

An external JavaScript BigInt calculation was used to generate the limb fixture
and cross-check the displayed equality. It is a discovery/fixture-generation
instrument, not a project runtime dependency, native test or theorem authority.
All implementation and executable test logic committed in this candidate is MIND.

The original patch was prepared without the pinned compiler. On 2026-10-11 the
unchanged checker and original harness were built with the exact pinned compiler
using its MLIR CPU backend and executed as a native ELF. Arithmetic checking,
refutation-template checking and all 1,240 original negative checks passed.
This does not establish accepted formal proof verification. See RESULTS.md for
observed results and limitations, TEST_CONTRACT.md for the unchanged original
contract, and MUTATION_CONTRACT.md for the separately declared source mutants.

```text
RESULT_STATUS=FORMALIZATION_BLOCKED
ARITHMETIC_CERTIFICATE=EXACT_FINITE_CHECK_PASSED
FORMAL_REFUTATION_CERTIFICATE=CANDIDATE
NATIVE_BUILD=PASS_MLIR_CPU_ELF
NATIVE_FINITE_TESTS=PASS_1240_ORIGINAL_NEGATIVES
GOVERNANCE_NATIVE_TESTS=PASS
INDEPENDENT_REVIEW=PASS_FINITE_SCOPE
NATIVE_PROOF_ACCEPTANCE=BLOCKED
MIND_MATH_PROOF_AUTHORITY=NOT_YET_ESTABLISHED
RH_PROVED=FALSE
```
