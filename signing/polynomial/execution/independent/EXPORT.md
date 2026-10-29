# Supporting independent verification receipt export

These files are outside the signed payload under `signing/polynomial/execution/`.
They report post-signature verification and do not recursively authenticate
themselves. No source or signed repository file was modified by this export.

The report, pre-execution declarations, exact execution script and all stdout,
stderr, exits, timings and hash receipts were copied. Only operational paths were
normalized: the independent scratch root to `/work/audit/independent-signature-review`,
the source repository to `/work/audit/release`, compiler executables to
`/work/compiler/math/mindc` and `/work/compiler/pqc/mindc`, and temporary wrapper
directories to `/work/audit/wrapper-scratch`. No verification result was changed.
Public-key data in verifier JSON is public and intentionally retained.

`EXPORT_MAP.tsv` records original/exported hashes for every copied file. Existing
hash receipts refer to the pre-normalization files and original run, not the
exported report or logs. `SHA256SUMS` is the exported-byte inventory, excluding
itself. Verify from this directory with `sha256sum -c SHA256SUMS`.

The complete public payload snapshots and negative-control copies remain local
working inputs; they are not duplicated here. The signed release contains the
original public inputs. `REVIEW.md` and `run-wrapper.sh` give the exact wrapper
command and control substitutions. The incomplete historical staging attempt is
preserved as failed supporting evidence; the separate complete historical check
passed all 1,506 files.

This receipt export contains no compiler executable, generated ELF, build cache,
private key, or signing seed. It confers no mathematical approval:
`FORMAL_PROOF_SUBMITTED` and direct-native `BLOCKED` remain unchanged.
