# Compiled checker mutations

Author: STARGA Inc.

The twelve defects were prelisted in `../TEST_CONTRACT.md`. Each `.diff.txt`
changes actual checker source. Fresh native builds, positive controls and
distinguishing invalid certificates are retained under `../evidence/mutations`.
All twelve builds succeed. Each accepts its positive control and wrongly accepts
the listed bad certificate; the unmodified checker normally rejects each bad
certificate. No crash, build error or timeout is counted as fault detection.

| Mutation | Positive | Bad certificate | Defect |
| --- | --- | --- | --- |
| M01 | P01 | N01 | Ignore coefficient equality |
| M02 | P03 | N03 | Ignore variable/exponent keys |
| M03 | P01 | N04 | Remove the three cooperating closedness guards |
| M04 | P01 | N10 | Ignore unused POLY_ID fields |
| M05 | P01 | N17, N38 | Discard coefficient overflow |
| M06 | P10 | N19, N37 | Allow exponent carry into another variable |
| M07 | P01 | N23 | Ignore trailing input |
| M08 | P15 | N28 | Ignore creation scope |
| M09 | P08 | N30 | Substitute the wrong nested binder |
| M10 | P01 | N12 | Ignore the declared goal |
| M11 | P16 | N21 | Admit 129 monomials |
| M12 | P01 | N22 | Ignore exhausted work budget |

N38 makes a symbolic coefficient of 10^36 appear to equal zero if truncation
is allowed. N37 makes x^33 alias y if packed exponent keys carry. These are
false mathematical equalities, in addition to the original true-but-out-of-cap
N17/N19 controls. N21 and N22 target resource-admission policy, not false algebra.
M11 safely increases cache stride to 13,424 bytes and moves its temporary to
offset 3,502,080 when raising the cardinality bound; memory corruption is not
used as a mutation result.

Reproduce independently for each ID. Stage the CLI as in `../REPRODUCE.md`,
then from its project root run:

```bash
patch --batch --fuzz=0 -p1 < "$package/mutations/M01.diff.txt"
```

The recorded mutation campaign used historical compiler
`a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa`
with LLVM 20. Repeating these mutations with the separately qualified public-source
compiler is a new qualification: preserve its new hashes/results and do not
expect historical executable digests without checking. Run both certificate
controls from the table through the resulting CLI, recording stdout, stderr
and exit codes separately. Both must print `KERNEL_CHECK=PASS`, exit 0, and have
empty stderr. Run the same invalid certificate through the baseline and require
`KERNEL_CHECK=FAIL`, exit 1, empty stderr. Use a fresh source copy for every
mutation. Match the source/executable digests in the corresponding receipts.

Initial scratch builds mistakenly placed modules outside the manifest's `src/`
directory and failed import resolution. They were corrected by staging the same
source bytes in `src/`; those build failures are retained under
`initial-layout-failure` and are not test results. Earlier successful receipts
preceding the final comment clarification are also preserved. Final runs are
all tied to the final source digest in `../RESULTS.md`.
