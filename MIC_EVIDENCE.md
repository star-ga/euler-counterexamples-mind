# MIC/MAP evidence scope

Author: STARGA Inc.

## MIND's documented signing capability

Official references: [MIND](https://mindlang.dev/),
[documentation](https://mindlang.dev/docs),
[MIC format](https://mindlang.dev/docs/mic),
[MAP metadata](https://mindlang.dev/docs/map),
[roadmap](https://mindlang.dev/roadmap), and
[RFC 0016](https://github.com/star-ga/mind/blob/main/docs/rfcs/0016-evidence-chain-emission.md).
The live documentation was rechecked on 2026-10-11.

The roadmap identifies optional evidence signing as shipped. Its hybrid uses
ML-DSA-87 and SLH-DSA-SHAKE-256s, with scheme identifier
`pqc-hybrid-ml-dsa-87-slh-dsa-256s`. Both signatures must verify; removing one
does not permit fallback to a weaker scheme. Signing requires a compiler built
with both `evidence-mldsa` and `evidence-slhdsa`, plus configured signing keys.
Unsigned emission remains available.

With a signing-enabled compiler configured for the documented hybrid scheme:

```sh
mindc example.mind --emit-evidence example.mic3
mindc verify --require-signed example.mic3
```

These commands illustrate the documented interface, not an execution receipt
for this Euler release. To bind a trusted hybrid signer, provide both full
public keys obtained independently, using repeated `--signer-pubkey` options
as implemented by `mindc verify`. An internally consistent signature alone does not
establish who controls the signing keys.

## Status of this Euler package

The release supplies a hybrid-signed package-provenance carrier, its exact
payload manifest, both public keys and reproducible verification commands in
[signing/](signing/README.md). The carrier's two signatures authenticate the
manifest digest; checking that manifest binds the listed proof artifacts.
Both signatures are embedded in the carrier. Git commits themselves remain
unsigned. This dedicated project key is not a previously established global
STARGA root; compare the public-key fingerprints through a trusted owner channel.

The [separate public signing profile](toolchain/public-pqc/README.md) is built
from pinned public compiler source with both required crypto features. The
historical mathematical compiler pin is unchanged. [Execution records](signing/execution/RESULTS.md)
describe actual signing, both-key authentication, metadata binding, tampering
controls and independent replay. The auxiliary [MIND binding checker](signing/map-binding/README.md)
requires the exact carrier profile and expected manifest digest.

This authenticates package bytes, not mathematical soundness or an equivalence
between source and executed machine code. The carrier program is deliberately
minimal and makes no claim to serialize the inference kernel.

## Historical compiler diagnostic

A bounded diagnostic used the historical compiler pin to emit the exact kernel
source with `--emit-evidence` and source-hash metadata, then verified the result
with `--require-strict-fp --require-deterministic` and inspected the IR.
Emission and verification succeeded, but inspection exposed a material limit:
the 20 kernel functions were represented by 60 instructions consisting of
constant-zero outputs. That summary does not encode the actual
kernel's control flow and arithmetic.

Consequently a valid trace hash for that MIC only checks the emitted
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
