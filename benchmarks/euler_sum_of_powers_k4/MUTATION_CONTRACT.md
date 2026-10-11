# Supplemental source-mutation contract

Author: STARGA Inc.

Frozen before compiling the supplemental probe or mutants. The original
TEST_CONTRACT.md and its 1,240-check harness remain byte-for-byte unchanged.
All executable test decisions remain MIND. This adds six direct negative
probes and positive/restoration controls in supplemental/main.mind.

Build four independently mutated copies of checker.mind, each with the original
harness and with the supplemental probe. Never mutate the production checker.

| Mutant | Exact semantic change | Required observed false acceptance |
| --- | --- | --- |
| positivity | Remove x<=0 only; retain tuple binding | Zero identity refutation |
| recomputation | Do not call fourth; parse bounded claimed power limbs into term; retain sum/equality checks | Changed arithmetic witness with unchanged powers, directly and with coherently changed refutation witness |
| binding | Remove tuple comparison only; retain positivity | Positive but mismatched refutation witness |
| eof | Remove cursor/length comparison only; retain parser failure check | Trailing LF in arithmetic and in refutation |

Baseline probe must exit 0, print six zero acceptance values, positive controls
and restoration PASS, and SUPPLEMENTAL_TESTS=PASS. Each mutant probe must build,
run to completion, retain positive/restoration PASS, print the designated false
acceptance(s), SOURCE_MUTANT_DETECTED=YES, and exit 1. Exit 2, signals, timeout,
compiler errors or missing evidence are infrastructure/control failures, never
successful fault detection. Unexpected observations require investigation.

The original 1,240-check harness is also run on every mutant. A surviving mutant
does not license changing that frozen count or hiding its output. In particular,
its changed-arithmetic-witness test calls refutation with the unchanged second
witness. Tuple binding can mask missing arithmetic recomputation. The additional
direct arithmetic and coherent-pair probes test that previously masked path.

Arithmetic checking, refutation-template checking and accepted formal proof are
separate. This campaign cannot validate a general proof calculus or authorize
NATIVE_VERIFIED. No RH progress is asserted.
