# Foundations and trust boundary

Author: STARGA Inc.

The intended model is the standard integers with exact addition,
multiplication, equality and strict positivity. Formula constructors have their
ordinary first-order meanings. Falsehood is never satisfied. Implication and
conjunction have their usual meanings; universal quantification ranges over
all integers. The proof only requires constructive natural deduction: no
excluded-middle or double-negation-elimination rule is implemented or needed.
The semantic soundness argument is mathematical prose, not a machine-checked
metatheorem about this kernel.

Numeral notation denotes the corresponding integer exactly. The supported
ground evaluator is a partial decision procedure for nonnegative expressions;
refusal on negative literals, variables, overflow or resource exhaustion is
incompleteness, never permission to assume the result. The logical formula
language can still quantify over negative integers. Standard integer and
finite-sequence mathematics underlie the soundness argument. There are no
imported theorem axioms, solver answers, cached PASS results, hash-as-proof
rules, unchecked oracle assertions or unresolved proof holes.

The object proof's sole nontrivial local assumption is C4, discharged by
negation introduction. An occurrence of an assumption has a unique identity;
identical formula text does not make two assumption occurrences interchangeable.
The final sequent must have no undischarged assumptions. The kernel's ground
arithmetic rules are trusted decision procedures whose connection to integer
semantics is justified separately in SOUNDNESS.md and checked in review.

The implementation/execution trusted computing base includes:

- The MIND parser, AST representation, scope/dependency bookkeeping,
  substitution/equality procedures, arithmetic evaluator, rule dispatcher and
  final-goal check in `src/kernel.mind`.
- The CLI's complete-input handling, allocation, byte access, and output/exit
  reporting. The benchmark harness is supporting test logic, not a proof rule.
- The exact pinned STARGA compiler, its MLIR CPU lowering/runtime shim, LLVM
  transformations, Clang, linker, linked C library and dynamic loader.
- The OS, CPU, memory, filesystem, process I/O and their correct execution of
  the resulting ELF; the integrity of the archived bytes and hash utilities.
- The interpretation of the certificate AST as the displayed mathematical
  theorem and the correctness of the metatheoretic argument/review.

A compiler hash identifies bytes; it does not prove a semantics-preserving
compiler. Backend/library hashes record the observed dependency closure of
this execution, not a reproducibly bootstrapped or formally verified toolchain.
No SMT implementation, Python, JavaScript, Julia, Lean, model output or remote
agent is a theorem-authority dependency. External diagnostic results, if
included, are explicitly separate and may be discarded without affecting the
native checker invocation.

PROOF_POLICY.md currently disables NATIVE_VERIFIED unconditionally. The
owner/designated verifier must approve the soundness rules, axiom handling,
certificate syntax, dependency closure, TCB and independent validation before
project acceptance is possible. Implementer and reviewer agreement cannot
supply that authorization. Certificate acceptance, independent source/rule
review and authorized kernel validation must be reported separately.
