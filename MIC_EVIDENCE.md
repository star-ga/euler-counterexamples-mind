# MIC/MAP evidence scope

Author: STARGA Inc.

MIND documents the [MIC format](https://mindlang.dev/docs/mic),
[MAP metadata](https://mindlang.dev/docs/map) and optional evidence signing.
Signing is not required for this public proof candidate. No signature or signer
identity is claimed for the supplied proof certificate.

A bounded diagnostic used the historical compiler pin to emit the exact kernel
source with `--emit-evidence` and source-hash metadata, then verified the result
with `--require-strict-fp --require-deterministic` and inspected the IR.
Emission and verification succeeded, but inspection exposed a material limit:
the 20 kernel functions were represented by 60 instructions consisting of
constant-zero/output/return forms. That summary does not encode the actual
kernel's control flow and arithmetic.

Consequently a valid trace hash for that MIC only authenticates the emitted
summary's internal consistency. It cannot attest source equivalence, native
executable semantics, certificate acceptance or mathematical soundness. No
kernel-attestation claim is made from this diagnostic, and that MIC is not
offered as a replacement proof artifact.

The actual proof-checking evidence is the complete MIND source, structured
certificate, successful native execution and documented checks. The relevant
compiler path is MLIR CPU lowering; MIC summarization is a different path.
Any future MIC-based kernel attestation must first demonstrate that it
faithfully represents this program, with an appropriate binding to the executed
artifact. Signing a lossy representation would not resolve that obligation.
