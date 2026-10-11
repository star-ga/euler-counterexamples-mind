# Foundations and trusted computing base

Author: STARGA Inc.

The intended model is the unbounded mathematical integers with ordinary addition,
multiplication, equality and ordering, and the logical meanings documented by
[NDv1](../finite_nd/FOUNDATIONS.md). NDv2 adds the commutative-ring polynomial
normalization argument and universal closure described in [SOUNDNESS.md](SOUNDNESS.md).
It does not add trusted user axioms, theorem-name lookup, a trusted computer-algebra
oracle, a PASS receipt or unverified certificate-supplied normal forms.

Trusted components include the exact checker source, its parser and workspace
accesses, arithmetic helpers, normalization and proof interpreter, the pinned
official compiler and CPU runtime, the OS/ABI, and hardware. Caller ownership and
immutability of the readable input and writable workspace are API preconditions.
The source and compiler have not been proved correct by a machine-checked
metatheorem. The soundness text is a mathematical argument requiring substantive
independent validation under the repository proof policy.

All executable proof checking, fixture generation and test decisions are MIND.
Shell commands stage files, invoke tools and collect receipts only. Exact digests
and observed commands/results belong in the final evidence package; a compiler
version label alone is insufficient. Signatures can establish artifact integrity
and provenance, not mathematical truth or soundness approval.

Explicit limitations:

- Only unsigned numeral syntax, addition and multiplication are normalized.
  Variables nevertheless range over all signed integers.
- There is no unrestricted universal introduction, general implication
  introduction, symbolic positivity inference, subtraction constructor, rational
  arithmetic, induction, existential rule or elliptic-curve library.
- A polynomial identity alone does not establish Elkies' curve equation for an
  arbitrary parameter, an infinite family of admissible parameters, positivity
  of resulting witnesses or infinitely many distinct primitive tuples.
- The scaled K4 equality holds for every integer scaling parameter. Positivity
  of a scaled counterexample requires n>0 separately; this candidate certificate
  does not prove that additional implication.
- Finite coefficient/degree/workspace limits cause refusal and never change the
  domain of universal quantifiers or silently approximate arithmetic.

Candidate status remains `FORMAL_PROOF_SUBMITTED` only after actual execution
evidence is recorded. `NATIVE_VERIFIED` remains disabled by the governing policy.
Independent agent review is identified as such; it is not an owner-designated
acceptance decision. No new counterexample discovery is claimed.
