The first batch was frozen in PREEXECUTION.sha256 and completed 64 calls with
zero mismatches before this follow-up was designed. Its exact harness is retained
as archive/main.initial.mind. No expected result was changed after execution.

The independent source reviewer proposed the distinction between multiplication
by an already empty zero polynomial and declaring an overdegree intermediate,
and duplicate insertion into a full 128-key destination. The other follow-up
cases target every coefficient limb and every packed exponent carry boundary.
FOLLOWUP.tsv is the predeclared second batch; PREEXECUTION_FOLLOWUP.sha256 pins it
and the expanded MIND harness before its execution. This is source-informed
regression testing, not blinded formal verification.

The first follow-up build and the first fresh-compiler build failed at link time:
the archived first-batch source was mistakenly placed as src/main.initial.mind,
and project-mode mindc compiles every source in src/. The linker reported duplicate
function definitions. Both failure receipts are retained under followup-* and
fresh-*. They are harness packaging failures, not successful checker detections.
The archived source and build directory were moved under archive/ before retry;
no test source, expected outcome, or kernel source was changed. New retry receipts
use followup-fixed-* and fresh-fixed-*. PREEXECUTION_LAYOUT_FIXED.sha256 records
the relocated inputs (AMENDMENTS.md was expanded after that hash to record this
failure explanation; the executable inputs retain their frozen hashes).
