# Public export and integrity

This package exports the independent polynomial boundary review and all its
build/run receipts, including both failed link attempts. No executable, compiler,
object/cache directory, key, internal handoff, or memory instruction is included.
MIND source files and all case expectations are byte-for-byte unchanged.

Only these operational location roles were normalized in copied text:

| Original location role | Exported location |
| --- | --- |
| Independent adversarial scratch root | `/work/audit` |
| Initial qualified compiler executable | `/work/compiler/initial/mindc` |
| Fresh source-rebuilt compiler executable | `/work/compiler/fresh/mindc` |
| Read-only pinned Euler source checkout | `/work/audit/euler-pinned` |
| Export reproduction-validation workspace | `/work/audit/reproduction-validation` |

Standard system paths such as `/usr/lib/llvm-20/bin` and `/usr/bin/time` retain
their operational meaning. Original private directory names are omitted.
The one factual prose correction in `REVIEW.md` is fully disclosed in `ERRATA.md`;
its uncorrected report remains in `archive/REVIEW.original.md` after path-only
normalization. No executable test source was corrected or regenerated for export.

`EXPORT_MAP.tsv` records every copied file's original-relative path, exported
relative path, original SHA-256, exported SHA-256, and transformation. New export
documentation and the reproduction script have no original file, denoted `-`.
The map excludes itself to avoid a self-referential hash; `SHA256SUMS` covers it.
`SHA256SUMS` hashes all exported bytes except itself. Verify it from this directory:

```bash
sha256sum -c SHA256SUMS
```

All other hash files are historical receipts. Their embedded digest values are
unchanged, while operational path labels may be normalized. They identify the
files as they existed during the original run, not the exported byte inventory.
In particular the old pre-execution records refer to the earlier source layout,
and `evidence/review.sha256` refers to the report before the disclosed correction.
Use `EXPORT_MAP.tsv` for the original/exported relationship and `SHA256SUMS` for
the current public package; do not treat a historical hash file as an export
manifest. Hashes and this export do not establish mathematical acceptance.

`run.sh` is preserved as historical command transport, with paths normalized.
Use the new `reproduce.sh` for fresh, arbitrary working directories. Its shell
only stages unchanged MIND files, invokes the compiler/programs, and records
receipts. All certificate construction and acceptance assertions remain MIND.

Status remains `FORMAL_PROOF_SUBMITTED`. Direct-native remains `BLOCKED`.
