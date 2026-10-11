# Public extraction record

Author: STARGA Inc.

The owner authorized a separate public Euler artifact on 2026-10-11.
This authorization does not publish any other repository or authorize a
NATIVE_VERIFIED claim. This repository has a fresh history and contains only
the Euler kernel, its earlier regression benchmark, and related review material.

The source export used tracked files from a frozen development commit. Local
build caches, lock files, object files and other untracked files were excluded.
All `.mind` implementation/test sources, certificate inputs, mutation diffs and
build manifests remain byte-identical to the reviewed development artifacts.
Verify them from the repository root with:

```sh
sha256sum -c publication/SOURCE_SHA256SUMS
```

Public text copies replace local home/scratch roots and machine aliases with
generic build/host labels. Some documents are updated to explain this release,
credit the known mathematics and identify AI-assisted review explicitly.
Consequently sanitized receipts are not byte-identical raw originals. Numeric
proof data, application output, exit codes, compiler/source/executable digests
and failures are not rewritten to improve the reported outcome.

`EXPORT_TRANSFORMS.tsv` records original and initial sanitized content digests
for automated operational redactions. Later editorial documentation changes are
identified by the public Git commit and release manifest, not by that initial
transformation list. Nested SHA256SUMS files are regenerated for public bytes;
historical execution manifests remain historical evidence where explicitly
labeled. The release manifest is the integrity authority for the public copy,
not a mathematical proof authority.

External tool diagnostics are optional context; no Sage, Lean, solver, Python,
JavaScript, Rust program or private research input is required by the MIND
checker executable. Compiler build tools and system libraries are separately
disclosed dependencies.

Current public prose uses the language name MIND. Historical source comments, build-manifest descriptions and frozen test records retain their original bytes so existing source hashes remain valid; this does not introduce a second language or implementation.
