# Public review submission: provenance and transformations

Author: STARGA Inc.

Status: **OWNER-AUTHORIZED PUBLIC REVIEW SUBMISSION, 2026-10-11.** This document
records an additive source/evidence publication. Formal acceptance remains open.

## Preserved identities

The unchanged public base is commit
`ae8423139ee67b57d8a43cf8aafff3bd6c5cc804`: all **1,601** tracked file bytes and
executable modes are preserved, including its existing README, license,
attribution, manifests and signatures. `BASE_PUBLIC_FILES.sha256` verifies those
files when invoked from the repository root. Their historical claims retain
their original scope. Existing signatures do not cover the polynomial extension.

The polynomial source snapshot identity is
`55cc2a903a90fb00a4c6167610ccc4d07fd9eb2a`. No Git directory, object database,
commit history or remote configuration is included. This opaque revision is
recorded only to identify the input snapshot.

All **77** protected artifacts are byte-identical to that input: **11 MIND
source files, 54 certificate files and 12 source-mutation diffs**. This includes deliberately
malformed certificate endings. `SOURCE_ARTIFACTS.sha256` lists their exact
hashes. The final kernel hash is
`7eed71f7cb06715744471edf80da5b6b1f3cdadb2ba345e3605814d2951fa3e2`.
No expected result, arithmetic rule, admission limit or mutation was changed.

## Declared transformations

`PUBLICATION_FILES.tsv` lists the original and exported SHA-256 for every
included input file. Files labeled `byte-identical` have no byte change.
Documentation and execution-path text in historical receipts use generic
`/work/toolchain/mindc` and `/work/scratch/{main,resource,cache,dump,mutations}`
placeholders. These replace machine-specific paths only; mathematical output,
exit values, measurements and observed compiler/program hashes are retained.
The export does not claim sanitized text is the original raw receipt bytes.
The additional historical comment-clarification diff has only its absolute
old-file header normalized to `/work/scratch/main/src/kernel.mind`; its hunks
and timestamp are unchanged. It is listed as transformed, separately from the
12 byte-identical source-mutation diffs.

Historical digest records retain their observed digest values and carry a
comment stating that they are historical. They may name original generated
executables or pre-sanitization output bytes. They are not the current export's
integrity manifest. The regenerated `SHA256SUMS` covers the current package;
verify it from `kernels/polynomial_nd`.

The package README, reproduction/result/evidence notes were adapted for a
standalone reader. Reproduction now identifies the separately qualified public
source-build compiler, while the old root compiler pin remains unchanged.
Unrelated research disclaimers were removed from new documentation. Original
root publication documents were not edited.

Full development-native diagnostic reports/traces and internal governance
receipts are excluded. A concise native blocker summary replaces the old
report, retaining exact diagnostic excerpts and explicit replay limitations.
The standalone scalar-control source/manifest remain unchanged; no scalar
success is counted as polynomial proof qualification. No compiler binary,
private compiler source, credentials, signing secrets, owner correspondence or
internal operational instructions are added.

## New execution evidence

The [public-source compiler qualification](evidence/public-source/RESULTS.md)
ran the unchanged three harnesses with compiler
`c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5`.
All 326 checker calls matched their expected results: 28 accepts and 298 rejects.
All six build/run exits were zero, stderr was empty and harness stdout matched
the historical final output bytes. Fresh receipt paths use declared generic
placeholders; their tool/input/output hashes identify the observed artifacts.

This initial qualification did not rerun the standalone CLI corpus. The later
[public-download replay](evidence/public-replay/RESULTS.md) repeated the three
harnesses and passed all 54 CLI certificates under the same compiler. The
historical extension mutation campaign, LLVM 23 and direct-native backend were
not rerun under that compiler; those profile obligations remain explicit.
Public reproduction depends on the pinned public compiler source,
supplied lockfile and the existing LLVM/MLIR build prerequisites; a different
compiler digest needs new qualification.

Engineering tests and the prose soundness argument do not grant formal
acceptance. The extension remains `FORMAL_PROOF_SUBMITTED`, with independent
acceptance obligations open. This submission selects no new publication license.

## Initial publication transition

Owner authorization on 2026-10-11 permits publishing this extension in the
separate public Euler repository as a draft pull request; it does not authorize
merging, a proof-status upgrade or publication of other repositories.
At public commit `5cca55f16a52f7dd468a7f19733ef2c2c54a497f`, relative to the
reviewed export, only this document, the package README and
the root `POLYNOMIAL_EXTENSION.md` change publication-status prose; the root
entry also explains the separate optional Arch-Mind integration.
An additive package `.gitattributes` exempts the intentional whitespace in one
malformed certificate, two ELF inspection receipts and three unified diffs
from editorial whitespace warnings. No fixture or receipt bytes are changed.
`PUBLICATION_FILES.tsv` updates the package README's exported digest and
`SHA256SUMS` is regenerated for these documentation changes. The 77 protected
source/certificate/mutation artifacts and all 1,601 original public files
remain byte-identical. Existing signatures retain their original scope and
do not cover this extension.

## Later documentation and receipt alignment

The subsequent documentation update adds `evidence/public-replay/RESULTS.md`,
its 183 stage streams/exits, the full CLI outcome table and a receipt export
map. Current entry points now distinguish this later replay from the initial
three-harness qualification. The per-file export map and package manifest
are updated for changed documentation and new receipts. Historical source and
execution identities remain explicit; no checker, certificate, mutation or
original signed-release byte changes. These additions are also outside the
earlier PQC signature scope.
