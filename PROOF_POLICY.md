# Proof status and review policy

Author: STARGA Inc.

This public artifact is submitted for independent review. Its current status is
FORMAL_PROOF_SUBMITTED. The certificate was accepted by the supplied candidate
kernel; this is distinct from validating that kernel's soundness.

Acceptance requires reviewed evidence tied to the exact theorem, rule system,
assumptions, certificate, checker source, toolchain and executed result. The
owner or a designated verifier must substantively approve soundness rules,
axiom handling, certificate syntax, dependency closure, the trusted computing
base and independent validation before NATIVE_VERIFIED may be enabled.

Public comments, signatures, source hashes, compiler success, finite tests and
AI-agent agreement do not automatically authorize that transition. There is no
named external human verifier or approved acceptance decision in this release.
Review findings and any future acceptance decision must identify the exact
artifact hashes, scope, assumptions and unresolved conditions.

The kernel's current soundness argument is mathematical prose. Its source,
compiler and runtime are not themselves proved correct by a machine-checked
metatheorem. An acceptance decision must preserve those limitations. This
package proves no RH claim and cannot change the status of other research.
