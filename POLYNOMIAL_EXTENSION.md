# Polynomial identity extension — public review submission

Author: STARGA Inc.

**PUBLIC REVIEW SUBMISSION. Owner-authorized publication, 2026-10-11.**

This additive snapshot preserves every tracked byte of public base
`ae8423139ee67b57d8a43cf8aafff3bd6c5cc804`, including existing license,
attribution, checksums and signatures. Its original README is unchanged.

The [polynomial extension](kernels/polynomial_nd/README.md) adds exact symbolic
normalization for universally quantified polynomial identities. Start with its
[syntax](kernels/polynomial_nd/SYNTAX.md),
[soundness argument](kernels/polynomial_nd/SOUNDNESS.md),
[reproduction](kernels/polynomial_nd/REPRODUCE.md) and
[326-call public-source compiler qualification](kernels/polynomial_nd/evidence/public-source/RESULTS.md).
Its status remains **FORMAL_PROOF_SUBMITTED**; formal acceptance is blocked.

[Transformation and integrity notes](kernels/polynomial_nd/PUBLICATION.md)
distinguish byte-identical checking artifacts from sanitized documentation and
receipts. No repository history, compiler binaries, credentials, signing secrets
or internal operational reports are included in the new extension.
The [existing license](LICENSE.md) and [attribution](PROVENANCE.md) are retained;
this submission selects no new license. Existing signatures do not attest the
new extension. Publication does not grant formal acceptance of the kernel.

## Optional architecture tooling

The [Arch-Mind integration draft](https://github.com/star-ga/euler-counterexamples-mind/pull/1)
documents optional architecture inspection for contributors with access to the
separately maintained private tool. It is a separate, unmerged change; this
extension does not require its code or access credentials. Arch-Mind reports
are development diagnostics, not proof certificates or mathematical authority.
All source and instructions needed for the proof checks are in this public
repository, with the public compiler and backend dependencies documented above.
