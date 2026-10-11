# Additive K5 statement-binding mutation contract

Author: STARGA Inc.

This additive contract is frozen before any mutated source is built or run.
It does not change the original 42 static cases, 1,045 prefixes, 1,045 corruptions
or their observed outcomes. The baseline source, compiler pin, certificate
fixtures and original PREEXECUTION.sha256 remain unchanged. Both bad controls
were already enumerated as static fixtures in that original contract.

Each variant changes only `binding.mind` in a separate scratch CLI project.
The generic inference kernel, CLI, certificate data and compiler are identical
to the baseline. These mutations test whether an accepted derivation of the
wrong statement can receive a C5 label; they do not forge arithmetic or claim
that the generic kernel accepts a false theorem.

| Mutant | Removed check | Designated wrong-goal certificate |
|---|---|---|
| M01_fifth_power_binding | Exact coefficient-one sum of fifth powers | B06_valid_square_refutation.nd.txt |
| M02_positivity_binding | Exact five-variable positivity conjunction | B04_missing_positive_hypothesis.nd.txt |

M01 replaces the final equation-structure predicate with acceptance after the
remaining goal-shape checks. M02 removes only the positivity-conjunction
predicate. Full diffs are in `mutations/`. Both certificates still have valid
generic inference derivations; their goals are not the specified C5 syntax.

For each mutant, in table order, build exactly once under the original
1-CPU/1-GiB build limit, then run these four calls in order:

1. Baseline CLI + P01: exit 0, `C5_BOUND_CERTIFICATE=PASS` and
   `FORMAL_ACCEPTANCE=BLOCKED`, each LF-terminated.
2. Baseline CLI + designated wrong-goal certificate: exit 1,
   `C5_BOUND_CERTIFICATE=FAIL` plus LF.
3. Mutant CLI + P01: same exit and output as control 1.
4. Mutant CLI + designated wrong-goal certificate: same exit and output as
   control 1, exposing the actual erroneous C5 label.

Every application stderr must be empty. Builds must exit normally with zero.
Executions use one CPU, a 256-MiB address-space limit, ten CPU seconds and a
fifteen-second wall timeout. An ordinary refusal by the mutant is a surviving
fault, not detection. A build error, crash, timeout, signal or wrapper failure
does not satisfy any control. Record all stdout, stderr, exit values and
mutant source/executable hashes. No edit to production source is authorized.
