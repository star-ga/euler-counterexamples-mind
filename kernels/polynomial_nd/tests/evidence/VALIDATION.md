# Adversarial test execution receipt

Author: STARGA Inc.

Date: 2026-10-11. Candidate checks only; formal acceptance blocked.

The test author froze the contract and mathematical outcomes before reading
the new checker implementation or executing it. The checker source was copied
verbatim for builds without source inspection. The test fixtures and builder
were developed from the legacy syntax and the parameter-capability audit.

The original plan hash is
`ce5200fa5afa14f3b6cd1d6e3f8a0bc8ff8916714ed4cc049f734f9a7a937317`.
`PREEXECUTION_FIXTURES.sha256` is the early pre-execution freeze of the builder,
suite, amendments, and first dump entry point. Before any execution, the dump
entry point was changed from a marked multi-certificate stream to an index
selector with exact certificate stdout. Its final pre-execution hash is kept
separately in `PREEXECUTION_DUMP_FINAL.sha256`; only that dump digest supersedes
the earlier entry. No fixture or expected outcome changed after the first run.

Tested checker source SHA-256:
`6b7c0afefd279c1b127ad074a8893dd3a11a6ca30e22a3118cb29631c0621542`.
Pinned compiler SHA-256:
`a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa`.
The compiler executable is
`/work/toolchain/mindc`.
Tool/source/binary identities and ELF inspection are retained alongside this
file. No binary is committed.

All three builds exited 0. The complete suite exited 0 with empty stderr:

```text
P01_BYTES=93
EXPECTED_ACCEPTS=24
EXPECTED_REJECTS=296
RESTORED_BINOMIAL=PASS
POLYNOMIAL_ND_TESTS=PASS
FORMAL_ACCEPTANCE=BLOCKED
```

The suite executed 321 checker calls: 54 new named cases, 57 legacy named cases,
17 strict legacy refusals, six API refusals, 93 proper prefixes, 93 invalid-byte
mutations, and one restored positive. The restoration adds one acceptance to
the printed 24: actual calls comprise 25 returns of 1 and 296 returns of 0.
Raw case-by-case outcomes are in `run.stdout`; the suite fails immediately on
an unexpected result, mutated input, or overwritten workspace guard.

The supporting resource probe exited 0 with empty stderr:

```text
P16_RESULT=1
P16_WORK_REMAINING=1990459
N22_RESULT=0
N22_WORK_REMAINING=0
RESOURCE_ISOLATION=PASS
FORMAL_ACCEPTANCE=BLOCKED
```

The 54 certificate-generation invocations all exited 0 and emitted no stderr.
Their exact bytes are hashed in `certificates.sha256`, and every generation exit
is retained in `generate.exits.tsv`. The MIND generator imports no checker.

One CPU (CPU 1) was used. Builds were limited to 1 GiB address space and 1800 CPU
seconds; tests to 256 MiB and 1800 CPU seconds; individual generator runs to
256 MiB and 60 CPU seconds. Wall-time measurements here are coarse process
receipts, not performance benchmarks. No other process was modified.

The integrator owns source-mutation builds, independent kernel review, and
overall acceptance. This receipt makes no claim that those separate obligations
have passed. Theorem statuses remain `FORMAL_PROOF_SUBMITTED`.
