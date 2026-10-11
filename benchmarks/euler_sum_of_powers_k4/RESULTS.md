# Euler K4 native finite-check evidence

Author: STARGA Inc.

Observed 2026-10-11 UTC. Exact arithmetic checking and restricted
refutation-template checking pass. **Accepted formal proof remains blocked.**
No RH progress is asserted. The result registry remains FORMALIZATION_BLOCKED.

The original patch SHA-256 is
`cee2786ca10fa363699a72120a0eb45552de20c046cd38348d1aed19fde1e838`;
it applied cleanly to `45a5492067f902c39851f11fc678060d7824c017`.
Its original file manifest is evidence/PATCH_SHA256SUMS.txt. The production
checker and four certificates retain those hashes. TEST_ADJUSTMENTS.md explains
the harness offset correction and separately added tests; TEST_CONTRACT.md is
unchanged. Retained initial receipts are historical attempts, not final results.

## Observed results

| Program / checker | Build exit | Original 1,240-check harness exit | Supplemental probe exit | False acceptances exposed by probe |
| --- | ---: | ---: | ---: | --- |
| Baseline | 0 | 0 | 0 | None; all six rejected |
| Positivity removed | 0 | 1 | 1 | Zero identity used as positive-domain refutation |
| Power recomputation removed | 0 | 0 | 1 | False arithmetic witness, both directly and coherently bound to refutation |
| Tuple binding removed | 0 | 1 | 1 | Positive mismatched witness |
| End-of-input check removed | 0 | 1 | 1 | Trailing arithmetic and refutation bytes |

Each row has separately built original-harness and supplemental-probe executables:
ten successful builds. Every mutant probe retains valid positive controls and
restoration checks, reports the specified invalid acceptance, and exits normally
with status 1. All ten final run stderr streams are empty. No crash, timeout or
build failure is counted as detection. The recomputation mutant **survives the
original harness**; the supplemental tests detect the previously masked fault.

The baseline original harness reports ARITHMETIC_CERTIFICATE=PASS,
REFUTATION_TEMPLATE=PASS, NEGATIVE_CASES_EXECUTED=1240 and FINITE_TESTS=PASS.
The supplemental baseline reports six additional negative checks and no invalid
acceptance. Positive controls include the supplied witness, the zero arithmetic
identity and restored original certificates. The main equality is checked with
bounded exact integer limbs, without floating point or an external solver.

## Compiler and execution boundary

Compiler: official installed MIND 0.10.2, core-ir 1.0, SHA-256
`a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa`,
matching toolchain/compiler.sha256. The public release with hash `3d54874d...`
was not substituted. Source receipt references revision
`5724a6ee44cc37fa6e432bf5fc237ef1b70e9624`; this is recorded provenance,
not an independently reproduced compiler-build attestation.

The build uses the compiler's explicit MLIR CPU backend with LLVM/Clang 20.1.8
and GNU ld 2.46, producing native Linux x86-64 ELF executables. It does not
qualify the separate native-emitter backend. The pinned build links an embedded
CPU runtime-support shim; no separately installed MIND shared runtime or language
interpreter was needed. System C libraries, linker inputs and compiler remain
part of the trusted execution boundary. Tool and observed dependency hashes are
retained, but a fully hermetic compiler/runtime closure is not established.

Builds are serialized on one CPU with nice 19, 1 GiB address-space limit,
50-second CPU limit and 60-second wall timeout. Runs use one CPU, 256 MiB,
10 CPU seconds and 15 wall seconds. The corrected baseline build took 0.83 s
and 109948 KiB maximum RSS; its run used 8100 KiB. These are observations under
shared host load, not performance benchmarks. Resource receipts distinguish
pre-existing host OOM events from this campaign. No GPU workload was scheduled.

## Evidence and remaining obligations

REPRODUCE.md gives complete build/run and mutation setup commands. Per-variant
stdout, stderr, exit, timing and ELF hashes are in evidence. The top-level
SHA256SUMS binds source, certificates, contracts and mutation patches; the evidence
manifest binds retained receipts separately. Native governance results and
independent review are recorded alongside the execution receipts.

The six-step mathematical argument uses numeral membership/positivity,
arithmetic equality, an assumed C4, universal elimination and implication
elimination, contradiction, and discharge of that assumption. The executable
recognizes one fixed derivation template; it does not implement validated
inference rules or prove soundness of the compiler/arithmetic-to-logic bridge.

Remaining formal blockers are documented semantics and numeral/arithmetic bridge,
validated proof rules and axiom handling, dependency closure, trusted-checker
validation and owner/designated-verifier acceptance under PROOF_POLICY.md.
Finite tests, mutation detection and independent review do not close them.
Remote CI additionally requires the repository's dedicated isolated runner;
local governance execution does not establish remote CI enforcement.
