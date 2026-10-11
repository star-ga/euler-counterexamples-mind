# Test source adjustments

Author: STARGA Inc.

The initial suite build stopped before execution with an unresolved imported
`fixture_count`. The four functions `fixture_count`, `fixture_name`,
`fixture_expected` and `fixture_certificate` now have public module visibility.
Certificate bytes, cases, expected outcomes, negative-control counts, source
mutations, and proof rules are unchanged. A failed build is not a passing test.

The initial manifest is preserved as `history/PREEXECUTION_INITIAL.sha256`,
SHA-256 `d6f83f8548f52445f9865a3cb7c5c5695ff33ec20f756825c311d6aa1831748b`.
It describes historical source bytes and is not the current verification list.
`PREEXECUTION.sha256` is regenerated before the first executable suite run.
Root orchestration retains the initial build stdout, stderr and exit status
alongside the corrected build evidence.

Public visibility alone did not resolve the build. A second attempt with the
entry and helper modules at the project root still failed before execution.
The pinned compiler resolved both imports when all three files were staged in
the conventional `src/` directory and the manifest entry was `src/main.mind`.
`Mind.toml` now records that staging layout. No fixture concatenation or change
to executable test logic is required. The unsuccessful visibility-only manifest
is preserved as `history/PREEXECUTION_VISIBILITY_FIX.sha256`, SHA-256
`05ff688d7ddf718a64856ebf1f06ac60116b666e2864dc2bbae2178c33fa4706`.

Two diagnostic concatenation attempts also failed to resolve the remaining
kernel import with a root-level entry. Their failed build receipts are retained;
concatenation was not adopted. The successful diagnostic used the unchanged
MIND source bytes in `src/`, built under one CPU and a 1 GiB address-space
limit, then ran all eight accepts and 1,585 rejects with exit 0 and empty stderr.
The fixture contract had been frozen before that execution. Root reproduction
uses the final manifest and retains its own build/run receipts.
