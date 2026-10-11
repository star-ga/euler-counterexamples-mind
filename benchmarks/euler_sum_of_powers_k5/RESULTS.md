# K5 observed native results

Author: STARGA Inc.
Date: 2026-10-11

The unchanged inference kernel and the new exact-C5 binding accepted the
1,045-byte Lander–Parkin certificate. The benchmark remains
`FORMAL_PROOF_SUBMITTED`; project kernel-soundness acceptance is outstanding.

## Artifact identity

| Artifact | SHA-256 |
|---|---|
| Compiler | `a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa` |
| Unchanged generic kernel | `ca181abc7430c32c324d10653fba3cca47cbf9a2d2cea30a5c97ec0ac4e13128` |
| Exact-C5 binding source | `1c3e7324cefd9d27cd5497e901267837fa47722ee86209d3145f9ef55dfbdc77` |
| Test harness source | `abe6ef6da2f002c3bd7d5c8debc7a8b211e0ecdcb1b5ef3217cbae667ce6961c` |
| Static fixture source | `bd8ccc1cb712401a4823924f72c292c8572eb0e9ea893f9a07658724ffa77ecc` |
| CLI source | `939af3e0f13b77c4a626d5b87e2e2a8da7acfc2b316b40cf3dbdc9e731bb0895` |
| P01 certificate | `5cac88773a9ec4893b906342a6fa0037d3e404b25da6f8d7eedab4e58ca1e06a` |
| Pre-execution manifest | `37b16273c841198e04649060092666970988fba6245ae5bfcf9d1c8b0d8ccb44` |
| Frozen test contract | `b02366b411805ccbd8f94ab51d3f9aae0c91a9dee6174d10b09b17ff08bb9c0f` |
| Test harness ELF | `6ea17d9ac45a95c159bb161a7f0c4f12b9fab479f332528ffb7634da2453fd8e` |
| CLI ELF | `3feb32223ac15ec3c488214515d12ceaac67ea535a53df1bffa19a4c7138db02` |

Both builds used explicit MLIR CPU lowering with LLVM/MLIR/Clang 20.1.8.
No compiler pin or existing K4 source was changed. The compiler, lowering,
runtime, kernel and statement-binding wrapper remain trusted implementation
components; neither source hashes nor native compilation prove them correct.

## Executed outcomes

| Check | Observed outcome |
|---|---|
| Correctly staged source checks | Suite and CLI: exit 0, empty stderr |
| Native builds | Suite and CLI: exit 0, empty stderr |
| Static paired fixtures | All 42 generic/bound expected pairs matched |
| Generic acceptance controls | 10 static accepts, including seven valid alternative statements |
| C5-bound acceptance controls | Three static accepts, including a redundant proof line and an unused term |
| Proper-prefix controls | All 1,045 prefixes rejected by both paths |
| Single-byte corruption controls | All 1,045 ASCII-X mutations rejected by both paths |
| Restored P01 | Accepted by both paths after every changed byte was restored |
| Exact negative counts | Generic 2,122; C5-bound 2,129 |
| Full suite | Exit 0; empty stderr; `K5_TESTS=PASS`; formal acceptance blocked |
| CLI P01 | Exit 0; `C5_BOUND_CERTIFICATE=PASS`; formal acceptance blocked |
| CLI B01, B06, N01 | Each exit 1, `C5_BOUND_CERTIFICATE=FAIL`, empty stderr |

The suite executes 2,133 paired cases: 42 static, 1,045 proper prefixes,
1,045 single-byte corruptions and one restoration. Each pair invokes the
generic checker directly and through the C5 wrapper, for 4,266 kernel calls.
The final restoration is additional to the reported static acceptance counts.
The standalone CLI adds four predeclared process invocations. All refusals
above were normal returns; crashes, signals and failed builds were not counted.

Every one of the 53 pre-execution manifest entries matched before and after
execution. Source formatting occurred before the manifest was frozen. No case,
certificate or expected outcome was altered after execution began.

## Resources and preserved diagnostic failure

Builds ran at nice 19 on one CPU, with a 1 GiB address-space limit, 50 CPU
seconds and a 60-second wall timeout. The suite build took 12.80 seconds and
peaked at 233212 KiB RSS; the CLI build took 0.98 seconds and peaked at
109548 KiB RSS. The suite run took 0.03 seconds and peaked at 7996 KiB RSS,
under a 256 MiB address-space limit, 10 CPU seconds and a 15-second wall timeout.
The host-wide `oom_kill` counter stayed at 1. This is a host-wide observation,
not a claimed isolated cgroup delta.

An initial source-only check was invoked directly on the new benchmark files,
where the central kernel was deliberately not copied. It failed with E2003
unresolved `finite_nd_check` calls. The preserved `initial-source-check.*`
receipts describe that assembly error, not a mathematical rejection. Copying
the exact central kernel into the documented scratch-project `src/` layout
made both staged source checks and both native builds succeed without source
or contract changes.

The implementation agent produced these local receipts. Independent source
review, replay and any signature evidence must be reported separately with
their own scope and hashes. They cannot silently promote the formal status.
