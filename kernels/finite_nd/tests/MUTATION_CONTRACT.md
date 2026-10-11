# Source mutation contract

Author: STARGA Inc.

This contract is declared before any mutation build or execution. Each mutation
applies to the candidate `src/kernel.mind`, independently in a disposable build
tree. The source must match the recorded baseline hash. Each diff must apply
exactly once; no mutation is combined with another. Production source is unchanged.

A mutation is detected only when all these observations hold:

1. The baseline accepts P01 and P02, and rejects the designated bad fixture.
2. The mutated source successfully builds to an executable ELF.
3. The mutant still accepts P02 with exit 0 and `KERNEL_CHECK=PASS`.
4. The mutant accepts the designated bad fixture with exit 0 and
   `KERNEL_CHECK=PASS`, while stderr is empty.

Build failure, crash, timeout, rejected positive control, and ordinary rejection
of the bad fixture are not mutation-test success. CLI output uses a generic
checker label and does not claim that arbitrary accepted input refutes C4.

| ID | Deliberately removed obligation | Bad fixture | What acceptance demonstrates |
|---|---|---|---|
| M01 | Structural universal-instantiation result check | N03_invalid_instantiation.nd.txt | A false `not(forall x : Z, x=x)` can be introduced. |
| M02 | Replacement-term equality inside substitution | N04_witness_mismatch.nd.txt | Instantiation at zero can claim the body at one; this is an invalid derivation, although its final formula is true. |
| M03 | Recomputed equality comparison | N01_forged_ground_equality.nd.txt | The false integer equation 0=1 can be introduced. |
| M04 | Creation-context accessibility | N49_closed_creation_context.nd.txt | A line from a popped inner scope can be reused. Dependencies remain active, so this isolates the stricter creation-context rule; no false-theorem claim is made. |
| M05 | Discharged antecedent matches the actual assumption | N06_wrong_discharge_formula.nd.txt | Discharging Bottom can falsely conclude not(1>0). |
| M06 | Recomputed strict positivity | N02_zero_positive.nd.txt | The false inequality 0>0 can be introduced. |
| M07 | Exact end of input | N39_trailing_lf.nd.txt | An extra trailing byte is incorrectly admitted. |
| M08 | Unique assumption occurrence identity | N07_reused_scope_depth.nd.txt | Reusing the stack depth as the assumption ID makes old Bottom accessible under a new assumption and falsely concludes not(1>0). |

The false-goal scope attack N05 is a separate baseline negative control. M04
alone intentionally retains dependency and final-closure checks. M08 tests the
stronger N07 false-goal attack by deliberately reusing discharged assumption IDs.
The single-bound-variable replacement is live for closed universal premises;
an outer-free-variable decrement-only mutation is unreachable through this API
and is not represented as a successfully tested mutation.

Diff files carry source lines, not precompiled binaries. Root orchestration
records compiler/source/executable hashes, exact commands, stdout, stderr and
exit codes for every row. A passing campaign remains finite implementation
evidence and does not by itself validate the proof calculus or promote status.
