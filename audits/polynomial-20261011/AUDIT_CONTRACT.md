# Independent polynomial audit contract

Author: STARGA Inc.
Date: 2026-10-11

Pinned public Euler commit: cacb9492a0c356dd094d08972910fda9232b4472.
Compiler source: public star-ga/mind commit 5724a6ee44cc37fa6e432bf5fc237ef1b70e9624.

Before execution, freeze repository files, the 54-case manifest and certificates,
and the supplied Cargo.lock. Fetch compiler source anonymously into a fresh
directory; compile without network using read-only downloaded registry sources,
the original release profile, a fresh target directory, one CPU, nice19, a
2 GiB memory cgroup with zero swap, and a 600-second deadline. Record actual
compiler hash, build logs and resource observations. No shared toolchain changes.

Build the documented three polynomial MIND harnesses and generic CLI with the
fresh compiler through LLVM/MLIR20 CPU. Require all harness outcomes and all
54 CLI stdout/stderr/exit results to match the frozen expectations. A compiler
failure, crash or timeout is a failure of the run, never successful rejection.
Record hashes and exact commands. Recheck inputs after execution.

Separate source reviewers independently examine normalization over all integer
assignments and numerical/parser/scope boundary cases. New independently designed
cases have their own frozen pre-execution lists; exploratory findings are labeled.
Passing finite cases does not establish universal soundness. Findings require
source lines, commit identity and reproducible evidence where executable.

Do not change FORMAL_PROOF_SUBMITTED or the direct-native BLOCKED state. After
verification, add a separate polynomial provenance manifest and PQC artifact,
preserving the historical K4/K5 signed artifact and its bound payload bytes.
Cryptographic authenticity is not mathematical soundness approval. This audit
does not supply designated external/human formal approval.

Compiler/source review, new mathematical review, test execution and MIND-Lab
continuation are separate lanes. Existing RH/MIND-Lab work and credentials remain
private and untouched by this public audit.
