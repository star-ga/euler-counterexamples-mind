# Symbolic polynomial identities in MIND

Author: STARGA Inc.

Status: **FORMAL_PROOF_SUBMITTED**. This candidate extends the bounded NDv1
checker with one rule, `POLY_ID`, that proves universally quantified polynomial
equalities by exact symbolic normalization. It does not sample variable values
or recognize a particular theorem name. The original K4/K5 checker remains
unchanged; the new version preserves its strict version-1 entry point.

The supplied certificates include these exact statements:

```text
For every n in Z: (n+1)*(n+1) = n*n + (2*n+1).

For every n in Z:
  (95800*n)^4 + (217519*n)^4 + (414560*n)^4 = (422481*n)^4.
```

Here powers abbreviate explicit multiplication ASTs, not a new trusted
operation. Each theorem is closed and assumption-free. The scaled K4 statement
is an elementary consequence of Frye's known counterexample; it is not a new
discovery or an infinite family of distinct primitive counterexamples.
Positivity of the scaled tuple requires n>0 separately.

The implementation supports one to four universal integer variables, exact
nonnegative coefficients below 10^36, exponents up to 32 per variable, at most
128 monomials per term, and a shared 2,000,000-operation normalization budget.
These are certificate-admission bounds; quantified integers remain unbounded
and may be negative. Subtraction, rational identities and the conditions needed
for Elkies' elliptic-curve construction are outside this profile.

- [Syntax and the new rule](SYNTAX.md)
- [Soundness argument](SOUNDNESS.md) and [foundations/TCB](FOUNDATIONS.md)
- [Reproduction](REPRODUCE.md) and [observed results](RESULTS.md)
- [Fixed adversarial contract](TEST_CONTRACT.md) and [test amendments](tests/TEST_ADJUSTMENTS.md)
- [Independent implementation review](tests/REVIEW.md)
- [Actual source mutations](mutations/README.md)
- [Public-source compiler qualification](evidence/public-source/RESULTS.md)
- [Review-export transformations and integrity](PUBLICATION.md)
- [Certificate inventory](tests/CASES.tsv)

This extension is published for independent review with owner authorization
dated 2026-10-11. Publication does not grant formal acceptance.

All executable checking, certificate generation and test decisions are MIND.
The tested historical compiler pin remains unchanged. LLVM 20 and LLVM 23.1.3
are separately identified backend profiles; matching outputs do not imply
identical executable bytes. The direct MIND native backend has a separate
compatibility assessment and is not silently substituted for the tested path.

Kernel acceptance and the recorded engineering review do not grant project
formal acceptance. PROOF_POLICY.md still requires substantive approval by the
owner/designated verifier of the rules, dependencies, TCB and validation.
The source/compiler correctness and normalization metatheorem are not themselves
machine-checked. The extension is not covered by the earlier public K4/K5 PQC
manifest or signatures.

Original implementation and formalization: STARGA Inc. Known witness provenance
is preserved in the original Euler benchmark. The K5 regression files here are
unchanged STARGA sources from public `star-ga/euler-counterexamples-mind` commit
`ae8423139ee67b57d8a43cf8aafff3bd6c5cc804`, not external theorem authority.
