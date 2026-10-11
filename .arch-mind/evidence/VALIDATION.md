# Architecture adoption validation

Author: STARGA Inc.

Executed 2026-10-11 against public Euler release
`ae8423139ee67b57d8a43cf8aafff3bd6c5cc804`, with additive architecture files.
No original tracked file was modified. The original source manifest passed
**88/88** entries and the original PQC payload manifest passed **1,506/1,506**
entries both before and after the change. This verifies listed file hashes;
it is not a new cryptographic signature or a re-signing of the package.

## Corrected tool defect

The old Arch-Mind function regex required `fn` immediately after indentation
or attributes. It omitted `pub fn`, including the checker entry point. Direct
reflection saw all 19 source paths but only **96 of 109 functions**. The newly
added independent per-file function count rejected that incomplete coverage.
The observed [stock gate stderr](stock-gate.stderr) and [exit](stock-gate.exit)
are retained.

The candidate tool permits the optional public visibility token in its function
declaration matcher. It preserves function names and includes the same bodies
in primitive/protection accounting. The upstream implementation and regression
tests remain in the separate Arch-Mind repository; proprietary tool source is
not copied here. Candidate commit:
`7c8ddedfde7b30058d6cb09d61e09df4c7ae146e`. This is an isolated candidate, not a
claim that every installed Arch-Mind CLI has been upgraded. Its full Python
regression suite passed **179 tests**, including 13 focused public-function
cases. The actual scanner CLI regression fails on the stock matcher and passes
on the candidate. The suite took 4.82 seconds with 56,064 KiB peak RSS.
The corrected reflector SHA-256 is
`efd229365e94c2d90fe9fab7c0522c39b36765de8d59c43cc9f0721ae8dc8d2b`.
All six exercised tool components are pinned by
[toolchain.sha256](../toolchain.sha256); obtaining a matching licensed tool
installation is an explicit prerequisite of this optional architecture gate.

## Observed source coverage and rules

Run from the repository root:

```sh
make --no-print-directory -f Makefile.arch-mind arch-check \
  ARCH_MIND_HOME=/path/to/qualified/arch-mind CPU=5
```

The [actual gate output](gate.stdout) is:

```text
rules: 1  scan_metrics: 9
OK: every rule passed.
MIND_SOURCE_FILES=19
MIND_REFLECTED_DECLARATIONS=109
ARCH_MIND_REFERENCE_GATE=PASS
```

Make exit status: **0**. Source coverage is retained in
[source-coverage.tsv](source-coverage.tsv), with exact source bytes in
[sources.sha256](sources.sha256). All 109 reflected declarations in this
release are functions. The aggregate architectural summary separately includes
7 modules / 38 symbols because upstream excludes benchmarks/tests. Its zero
dependency-edge count is not used as evidence of acyclicity or isolation.

The original-source baseline, repeat baseline and final adoption scan produced
identical normalized artifacts. Only absolute local snapshot paths are replaced
with `.` or `summary.json`; metric values and source bytes are untouched.

| Artifact | SHA-256 |
| --- | --- |
| Normalized raw reflection AST | `9574f7d45092ac8d64f45a5be4c16e0ab2a8a192239c8c8280f0b5edc41fe3af` |
| Summary | `c7a9d30063f638d2790030dd9a453689f2881df481326c0dc7950636ca86cd85` |
| Scores | `2767b247129a5e2f9510845ee0c5bc1a0bf881d64f77f207f7b24d8e378d117a` |
| Source hashes | `2b2d175c23dc5846399c731a995a6dc50b07141c127ed908a845998214432273` |

[Before summary](baseline-summary.json), [after summary](after-summary.json),
[before scores](baseline-scan.json) and [after scores](after-scan.json) are
included. The raw AST remains reproducible from the unchanged public source;
local snapshot copies are not needed in the repository.

## Actual fault controls

The pre-execution [test contract](TEST_CONTRACT.md) SHA-256 was
`208d062d3c7353077e10cf8a9dd06e7f80512e09c7a7f05213e194e3d47842aa`.
Both positive runs passed. All ten source/configuration fault controls rejected
normally with Make exit 2. The invalid declared rule produced Arch-Mind exit 1
inside Make, correctly propagated as Make exit 2. No timeout, build failure or
crash is counted as a successful negative control.

The cases cover private/public floating-point declarations, a public random
primitive, a kernel import, deleted source, an empty index, untracked source,
an actual failing enforced rule, a corrupt tool pin and a forged cached summary.
The exact appended declarations and rule changes are specified in the contract.
The [case exit table](controls.tsv) and [diagnostics](controls.stdout) retain
the outcomes. In public logs only local `wrote` and `Evidence:` path lines are
omitted; all rule and rejection diagnostics are retained.

## Environment and limitations

Linux x86-64; Python 3.14.4; GNU Make 4.4.1; jq 1.8.1; Git 2.53.0.
Tool calls ran on CPU 5, nice 19, with 1 GiB address-space, 50-second CPU and
60-second wall-clock caps. The final whole-gate run additionally ran under a
90-second outer deadline and 1 GiB address-space cap on CPU 5; it completed in
**1.42 seconds**, peak RSS **18,876 KiB**, exit **0**.
No GPU or network service was used and no local/global session hooks changed.

This is the external Arch-Mind reference CLI, not a demonstrated native MIND
Arch-Mind path. Its regex reflection is intentionally limited; full language
parsing and sound dependency resolution remain separate tool obligations.
In particular, the existing reflector can count function-shaped text in
multiline comments and does not recognize protection on a same-line attribute.
The tested public source avoids relying on those cases; this gate is not a
complete arbitrary-source coverage guarantee.
The native mathematical checker, existing tests, compiler pin, proof status,
public verification keys, signed carrier and payload manifest are unchanged.
No PQC private key was read, generated, imported or published by this work.
