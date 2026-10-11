# Arch-Mind adoption test contract

Author: STARGA Inc.

Declared before the qualified run. Every case uses a fresh temporary Git
repository containing the original 19 tracked MIND source files and the new
architecture gate files. No production proof source is changed. A failure is
counted only when the gate exits normally with a nonzero status and the
diagnostic identifies the intended rejection. A crash or timeout is not a
successful negative control.

| Case | Setup | Required observation |
| --- | --- | --- |
| B01 | Original source and matching tool pin | Exit 0, 19 files, 109 reflected functions/declarations, enforced rule PASS |
| B02 | Repeat B01 from an identical tree | Same normalized AST, summary, scores, source hashes and rule result |
| N01 | Append a private function containing `f64` to the kernel | Nonzero, primitive check rejects |
| N02 | Append a public function containing `f64` to the kernel | Nonzero, public function is reflected and rejected |
| N03 | Append a public function calling `random()` | Nonzero, nondeterministic primitive check rejects |
| N04 | Add `import other;` to the kernel | Nonzero, kernel dependency-boundary check rejects |
| N05 | Delete the indexed kernel source file | Nonzero, missing source fails before scanning |
| N06 | Remove every MIND file from the Git index | Nonzero, untracked-source or empty-input check rejects |
| N07 | Add a non-ignored untracked `extra.mind` | Nonzero, untracked-source check rejects |
| N08 | Require determinism score equal to 0 | Nonzero, actual Arch-Mind enforce rule fails |
| N09 | Corrupt one pinned tool digest | Nonzero, tool verification rejects before source scan |
| N10 | Forge a cached all-clear summary and apply N02 | Nonzero; a fresh source scan rejects the public floating-point declaration |

The unmodified installed reflector is also tested against the independent
per-file function count. Its failure on public functions is retained as a
tool defect, not called a passing architecture scan. The candidate upstream
fix has a separate regression suite and exact component hashes.

No test result is a mathematical soundness approval. Source/binary proof
regressions and PQC verification remain governed by their existing contracts.
