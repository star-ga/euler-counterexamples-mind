# K5 statement-binding mutation outcomes

Author: STARGA Inc.
Date: 2026-10-11

Both actual binding-source faults were exposed under the unchanged pinned
compiler. The additive contract and selected original fixture bytes were
frozen before either mutant was built. Its manifest SHA-256 is
`4d3bb824f86c808e00d2e025a0c343e797f603cc2b72db802820b6feb2484d44`.

| Variant | Build exit | Baseline positive / bad | Mutant positive / bad |
|---|---:|---|---|
| M01_fifth_power_binding | 0 | 0 / 1 | 0 / 0 |
| M02_positivity_binding | 0 | 0 / 1 | 0 / 0 |

Every positive and mutant-bad stdout was exactly
`C5_BOUND_CERTIFICATE=PASS` plus LF followed by `FORMAL_ACCEPTANCE=BLOCKED`
plus LF. Every baseline-bad stdout was exactly `C5_BOUND_CERTIFICATE=FAIL`
plus LF. Every build and application stderr was empty. No crash, build
failure, signal or timeout counted as detection.

M01 accepted the valid square-refutation certificate B06 with the wrong C5
label. M02 accepted B04, whose valid derivation negates a conjecture lacking
the first positivity hypothesis, with that same wrong label. The generic
inference kernel continued to check real derivations in both cases: these are
statement-binding faults, not claims of a false theorem accepted by the kernel.

| Variant | Mutated binding source SHA-256 | Mutant ELF SHA-256 |
|---|---|---|
| M01 | `b9449c392234f4f5269f0fb24ce404893555153690cdab12573a4f0fa63c7a9b` | `78df82c4bc22e149b0d89b686bca4cf3348c435a31b03d0fa0051a169ee21d8b` |
| M02 | `0b39f03383e60fe684dc9f5908f118ef1cadc09486d805edc042c5bc707803c8` | `acd081d892434c41597187a880b468397b3bd0a2b388bb4b9e0a2023b177cf29` |

Before compilation, a fresh unified diff of each actual scratch source was
byte-compared with its frozen patch. The original binding source, generic
kernel, CLI and original test contract were not modified. Both additive
pre-execution and post-execution manifest checks passed. The original
PREEXECUTION.sha256 remains unchanged.

All builds used one CPU, nice 19, a 1-GiB address-space limit and timeouts;
each run used one CPU and 256 MiB. Receipts are under `evidence/mutations/`.
Only scratch path metadata in two source-hash receipts was replaced with the
neutral `/BUILD_ROOT` label; original/public content digests are recorded in
that directory's EXPORT_TRANSFORMS.tsv. Application output, exit values,
arithmetic data and source/executable hash values were not changed.

These tests extend finite engineering evidence. Kernel soundness approval,
independent review and project formal acceptance are separate obligations.
