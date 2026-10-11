# Observed symbolic-kernel validation

Author: STARGA Inc.
Date: 2026-10-11

Final checker SHA-256:
`7eed71f7cb06715744471edf80da5b6b1f3cdadb2ba345e3605814d2951fa3e2`.
Historical compiler SHA-256 (unchanged):
`a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa`.
The historical campaign below used that compiler. The separately qualified
[public-source profile](evidence/public-source/RESULTS.md) passes all 326 harness
calls with compiler `c6a4cdce...811ea5`; it does not transfer all historical
mutation/backend qualifications to that compiler.

All successful proof/test builds below emitted Linux x86-64 ELF through the
explicit MLIR CPU path. This is distinct from direct native-backend admission.

| Check | Actual result |
| --- | --- |
| Symbolic public-API suite | 321 calls: 25 accepts, 296 rejects; exit 0 |
| Capacity/work diagnostic | 128-monomial control accepted; exhaustion rejected with zero budget remaining |
| Cache diagnostic | Two valid accepts and one false second-rule refusal; budget not reset |
| Combined three harnesses | 326 calls: 28 accepts, 298 rejects; all exits 0 |
| Standalone certificates, LLVM 20 | 16 accepts, 38 ordinary refusals |
| Standalone certificates, LLVM 23.1.3 | Same 54 stdout/stderr/exit outcomes |
| Three harnesses, LLVM 23.1.3 | All build/run exits 0; stdout identical to LLVM 20; stderr empty |
| Actual source mutants | 12/12 build, retain positive control and accept distinguishing invalid certificate |
| Stronger overflow/carry mutants | M05 accepts false N38; M06 accepts false N37; baseline refuses both |
| K4 legacy API regression | Eight accepts, 1,585 rejects, restored Euler acceptance; exit 0 |
| K5 legacy API regression | Ten generic/three bound static accepts; 2,122 generic/2,129 bound rejects; restored acceptance; exit 0 |
| Prior independent-review corpus | 33 cases pass with new version-1 entry point; exit 0 |
| Original four-stream template regression | Exact arithmetic and template pass; 1,240 negative checks; exit 0 |
| Independent implementation review | PASS_WITH_NOTES; one comment correction resolved; no soundness defect found |
| Project formal acceptance | BLOCKED; FORMAL_PROOF_SUBMITTED only |

The main suite's printed `EXPECTED_ACCEPTS=24` excludes its final separately
labeled restoration acceptance. The K5 restoration call is likewise reported
separately from the static accept counts. Counts from different corpora must
not be added as if all input cases were distinct.

LLVM 20 checker ELF:
`c7a63b0503af8c338821c07ea9433f68c0545fa12699fbbda7706797d97a8ce8`.
LLVM 23 checker ELF:
`c92542160bde0d3908d0a364b17d55091c965937a7b0d2392af3e77507618160`.
They differ; only the recorded observable results match across these profiles.
The exact tools, runtime libraries and dependencies are identified in
`evidence/llvm20`, `evidence/llvm23` and `evidence/runtime.sha256`.

Direct native-backend qualification remains blocked. Historical compatibility
attempts refused unresolved allocation/printing calls or the modulo construct
before producing a checker executable. The [scoped blocker summary](evidence/native/REPORT.md)
retains the exact diagnostic text and separates this limitation from the working
MLIR CPU profile. No direct-native checker acceptance is claimed.

The independent reviewer authored the tests but not the implementation. That
independence scope and the absence of owner/designated-verifier approval are
explicit in `tests/REVIEW.md`. A prose soundness argument and agent review are
not a machine-checked metatheorem. The normalized polynomial semantics cover
all integer environments, but implementation/compiler correctness remains in
the documented trust assumptions.

The original case contract was frozen before execution. Its amendments document
the work-exhaustion fixture correction, stronger overflow/key-carry cases and
source-informed cache supplement. No expected result was changed to fit a run.
One initial CPU-affinity selection was outside the allowed 0..11 set and was
corrected before the initial successful build. Initial mutation project-layout
failures are retained and excluded from detection counts. A source comment-only
repair was followed by fresh builds/runs of the final exact source.

Receipts record exit values and observed stdout/stderr; local paths in this
review export were sanitized as described in `PUBLICATION.md`. Builds/runs used bounded
single-CPU invocations and explicit address-space caps; no other sessions or
toolchain configuration were changed. These observations do not establish a
new mathematical discovery, a general complete theorem prover or
authorization to publish this extension.
