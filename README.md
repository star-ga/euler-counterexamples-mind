# Euler K4 counterexample: a MIND proof-checker candidate

Author: STARGA Inc.

Public review copy. [Existing all-rights-reserved terms](LICENSE.md) are retained;
publication does not select a new open-source license.

This repository contains the complete MIND source of a small inference
kernel, a structured certificate, executable tests and recorded verification
evidence for the known identity

**95800^4 + 217519^4 + 414560^4 = 422481^4.**

The certificate derives the negation of

`C4 := forall a,b,c,d : Z. ((a>0 and b>0) and (c>0 and d>0)) -> not(a^4+b^4+c^4=d^4)`.

The checker recomputes the arithmetic exactly, checks each universal
instantiation and inference, tracks assumptions and discharges the assumed C4.
It is a generic bounded natural-deduction checker, not a fixed Euler template.
Quantifiers range over all integers; implementation bounds cause rejection
rather than changing the mathematical domain.

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

## Executed checks

The recorded campaign accepted the Euler certificate, passed eight positive
fixtures and 1,585 expected rejections, passed 33 separately authored cases,
and exposed eight actual checker-source mutations with valid positive controls.
The earlier arithmetic/template benchmark and its 1,240 negative tests are
retained unchanged as [regression evidence](benchmarks/euler_sum_of_powers_k4/README.md).
That earlier recognizer is not the inference kernel.

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

[MIC/MAP limitations](MIC_EVIDENCE.md) explain why a verified hash of the
compiler's lossy IR summary is not used to attest this kernel's full semantics.

This is STARGA's implementation and formalization of Roger Frye's published
counterexample, not a new mathematical discovery. It makes no RH progress claim.
Only this isolated artifact is authorized for public release; other research
repositories and their histories are not included.
