# Source-built compiler: mutation qualification

Author: STARGA Inc.

The separately rebuilt public-source compiler `c6a4cdce...811ea5` compiled all
eight unchanged mutation diffs. Each baseline accepted P02 normally and rejected
its mapped bad fixture normally. Each mutant retained P02 acceptance and wrongly
accepted its mapped bad fixture. Every successful control had the specified
stdout, empty stderr and normal exit status. See the original mutation contract
for why each fault is meaningful; M02, M04 and M07 are not false-theorem claims.

| Mutant | Build | Baseline positive / bad | Mutant positive / bad |
|---|---|---|---|
| M01 | 0 | 0 / 1 | 0 / 0 |
| M02 | 0 | 0 / 1 | 0 / 0 |
| M03 | 0 | 0 / 1 | 0 / 0 |
| M04 | 0 | 0 / 1 | 0 / 0 |
| M05 | 0 | 0 / 1 | 0 / 0 |
| M06 | 0 | 0 / 1 | 0 / 0 |
| M07 | 0 | 0 / 1 | 0 / 0 |
| M08 | 0 | 0 / 1 | 0 / 0 |

Public receipt copies are in evidence/mutations. Compiler, source and executable
digests bind this result to the tested bytes. All builds used one CPU with a
1 GiB address-space cap; executions used 256 MiB with timeouts.

An earlier orchestration attempt is retained in evidence/mutation-attempt1.
Its shell capture helper accidentally changed the caller's label variable,
causing compound receipt names and attempts to invoke nonexistent executables.
Those exit-127 failures are not counted as successful mutation checks. The
helper variables were scoped locally and the entire eight-mutant campaign was
rerun. No MIND source, fixture or expected test outcome changed to obtain the
successful result above. These are finite tests, not kernel-soundness approval.
