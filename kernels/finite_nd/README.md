# MIND natural-deduction kernel candidate: Euler K4

Author: STARGA Inc.

Publication disclosure: review was performed by an AI agent assigned separately
from implementation. It was not external human validation. Any approval still
follows the public PROOF_POLICY.md.

The native checker accepts a structured derivation of **not C4**, where C4 says
that no positive integer quadruple satisfies `a^4+b^4+c^4=d^4`. It evaluates the
four positive witnesses and their equality exactly, instantiates an assumed C4,
derives Bottom and discharges that assumption. This is a generic inference
checker with explicit syntax and checked premises, rather than the earlier
fixed-template recognizer. The latter remains unchanged as regression evidence.

**Certificate acceptance is observed. Project formal acceptance remains
blocked.** The rules, arithmetic bridge and implementation have independent
source/mathematical review and adversarial execution evidence. That review is
not an authorized declaration that the kernel has been validated under
PROOF_POLICY.md, nor a machine-checked metatheorem about the checker/compiler.
The derivation is submitted for the owner/designated verifier's acceptance.

- [Exact theorem and witness](STATEMENT.md)
- [Certificate AST and all 16 inferences](certificates/EULER_TABLES.md)
- [765-byte certificate](certificates/P01_euler_c4_refutation.nd.txt)
- [Syntax, rules, assumption tracking and bounds](SYNTAX.md)
- [Rulewise soundness and arithmetic bridge](SOUNDNESS.md)
- [Foundations, assumptions and TCB](FOUNDATIONS.md)
- [Observed tests, mutation outcomes and limitations](RESULTS.md)
- [Independent review](REVIEW.md)
- [Reproduction](REPRODUCE.md) and [owner-review release package](RELEASE_REVIEW.md)

The exact compiler is `a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa`,
using the same explicit MLIR CPU configuration as the original benchmark campaign. The compiled program
has no Python, Lean, solver or private RH runtime dependency. Resource bounds
restrict accepted certificate size and computable ground expressions; the
quantifiers in C4 still range over all mathematical integers.

```text
RESULT_STATUS=FORMAL_PROOF_SUBMITTED
KERNEL_CERTIFICATE_ACCEPTANCE=PASS
INDEPENDENT_SOURCE_RULE_REVIEW=PASS_WITH_NOTES
AUTHORIZED_KERNEL_SOUNDNESS_VALIDATION=PENDING
NATIVE_VERIFIED=NOT_AUTHORIZED
PUBLIC_RELEASE_AUTHORIZED=SEPARATE_ARTIFACT_ONLY
RH_PROVED=FALSE
```

This is a new implementation and formalization of a previously known
counterexample, not a new mathematical discovery. No RH progress is asserted.
