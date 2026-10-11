# Euler K4 and K5 counterexamples: a MIND proof-checker candidate

Author: STARGA Inc.

Built in [MIND](https://mindlang.dev/). Official references:
[language and compiler documentation](https://mindlang.dev/docs),
[MIC artifacts](https://mindlang.dev/docs/mic),
[MAP metadata](https://mindlang.dev/docs/map), and
[capabilities and roadmap](https://mindlang.dev/roadmap).

Public review copy. [Existing all-rights-reserved terms](LICENSE.md) are retained;
publication does not select a new open-source license.

This repository contains the complete MIND source of a small inference
kernel, structured certificates, executable tests and recorded verification
evidence for two known identities:

**95800^4 + 217519^4 + 414560^4 = 422481^4.**

**27^5 + 84^5 + 110^5 + 133^5 = 144^5.**

The certificate derives the negation of

`C4 := forall a,b,c,d : Z. ((a>0 and b>0) and (c>0 and d>0)) -> not(a^4+b^4+c^4=d^4)`.

The checker recomputes the arithmetic exactly, checks each universal
instantiation and inference, tracks assumptions and discharges the assumed C4.
It is a generic bounded natural-deduction checker, not a fixed Euler template.
Quantifiers range over all integers; implementation bounds cause rejection
rather than changing the mathematical domain.

The [K5 certificate](benchmarks/euler_sum_of_powers_k5/README.md) refutes the
analogous universally quantified positive-integer statement C5. It uses the
**identical kernel source and inference rules**. Its MIND wrapper additionally
checks that the accepted goal AST is exactly the stated negation of C5.

**Status: FORMAL_PROOF_SUBMITTED.** Certificate acceptance was observed under
the documented candidate rules. Kernel soundness has a prose argument and a
separate AI-agent review; no external human review or authorized kernel
validation is claimed. Public review is invited. A signature, test pass, AI
agreement or GitHub approval alone does not establish mathematical soundness.

## Start here

- [Exact theorem](kernels/finite_nd/STATEMENT.md) and
  [all 16 certificate inferences](kernels/finite_nd/certificates/EULER_TABLES.md).
- [MIND kernel](kernels/finite_nd/src/kernel.mind),
  [CLI](kernels/finite_nd/src/main.mind), and
  [765-byte certificate](kernels/finite_nd/certificates/P01_euler_c4_refutation.nd.txt).
- [Syntax and rules](kernels/finite_nd/SYNTAX.md),
  [soundness argument](kernels/finite_nd/SOUNDNESS.md), and
  [foundations/trusted computing base](kernels/finite_nd/FOUNDATIONS.md).
- [Reproduction instructions](REPRODUCE.md),
  [toolchain availability](toolchain/README.md), and
  [observed results](kernels/finite_nd/RESULTS.md).
- [Review findings](kernels/finite_nd/REVIEW.md) and
  [how to submit a substantive review](REVIEWING.md).
- [Historical attribution](PROVENANCE.md) and
  [publication transformations](publication/README.md).
- [K5 theorem, certificate and results](benchmarks/euler_sum_of_powers_k5/README.md).
- [PQC signatures, public keys and verification](signing/README.md).

## Executed checks

The recorded campaign accepted the Euler certificate, passed eight positive
fixtures and 1,585 expected rejections, passed 33 separately authored cases,
and exposed eight actual checker-source mutations with valid positive controls.
The earlier arithmetic/template benchmark and its 1,240 negative tests are
retained unchanged as [regression evidence](benchmarks/euler_sum_of_powers_k4/README.md).
That earlier recognizer is not the inference kernel.

The K5 suite passed 42 static paired checks plus 1,045 truncations and 1,045
single-byte corruptions: 2,122 generic rejections and 2,129 C5-bound rejections.
Seven valid proofs of other goals pass the generic kernel and fail the exact
C5 wrapper. Two actual wrapper-source mutants exposed removal of fifth-power
and positivity binding. [Second-machine replay](publication/k5-cross-host/RESULTS.md)
matched the historical K5 suite and CLI outputs and exit codes.

These counts describe finite executed checks, not a proof of all possible
kernel executions. The reported source review used another AI agent working
separately from implementation, on the same compiler. A second machine replayed
the same ELF; that was not an independent compiler build. Exact limitations and
failed attempts remain in the evidence.

## Reproduction boundary

All mathematical checking and executable test decisions are MIND.
Shell commands only assemble projects, invoke tools and capture results.
The original build used the exact compiler digest in `toolchain/compiler.sha256`
and MLIR/LLVM/Clang 20.1.8, producing a native Linux x86-64 ELF.
The same version number on another compiler does not identify the same build.
Public bootstrap availability and any separately tested profile are described
in `toolchain/README.md`; the historical pin is never silently replaced.

The [public-source bootstrap](toolchain/public-source/README.md) has now been
qualified: all four programs built and ran, and their ELF bytes matched the
historical artifacts exactly. The [eight mutations](toolchain/public-source/MUTATION_RESULTS.md)
also passed their defined controls. All four ELF files then produced identical
stdout, stderr and exit codes on a [second Linux machine](toolchain/public-source/cross-host-replay/RESULTS.md).
These are measured results for the documented hosts/backend, not a claim about
every architecture or a formally verified compiler.

The package uses MIND's optional hybrid post-quantum provenance facility,
**ML-DSA-87 + SLH-DSA-SHAKE-256s**. Both signatures are carried in a MIC/MAP
artifact that binds the payload manifest. See the [public keys and commands](signing/README.md)
and [execution evidence](signing/execution/RESULTS.md) to verify the signatures
and all listed files. [MIC/MAP scope](MIC_EVIDENCE.md) distinguishes this
package-provenance carrier from an attestation of the kernel's semantics.
Signatures do not validate the mathematical inference rules.

This is STARGA's implementation and formalization of the published Frye (K4)
and Lander–Parkin (K5) counterexamples, not a new mathematical discovery.
It makes no RH progress claim.
Only this isolated artifact is authorized for public release; other research
repositories and their histories are not included.
