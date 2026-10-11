# Polynomial release: separate hybrid PQC provenance

Author: STARGA Inc.

This directory binds the polynomial release and its
[independent audit](../../audits/polynomial-20261011/REPORT.md) using a new
manifest and MIC/MAP carrier. It is additive: the historical K4/K5
`signing/package.mic3`, `signing/PAYLOAD_SHA256SUMS`, public keys and all 1,506
historically bound files remain unchanged. Those older signatures retain their
original scope; they do not by themselves cover polynomial checking.

`package.mic3` embeds both ML-DSA-87 and SLH-DSA-SHAKE-256s signatures over a
carrier whose `org.starga.package_manifest_sha256` attribute commits to the exact
`PAYLOAD_SHA256SUMS` bytes. The carrier returns zero; it is a provenance container,
not the proof-checker program. Actual artifact hashes, verification results and
negative controls are recorded in [execution/RESULTS.md](execution/RESULTS.md).

## Public verification

Build the official compiler using the public
[mathematical profile](../../toolchain/public-source/README.md) and
[PQC profile](../../toolchain/public-pqc/README.md). Only public sources, locked
dependencies and public keys are needed. From a frozen checkout with no other
writer:

```sh
MINDC=/absolute/path/to/mathematical/mindc \
PQC_MINDC=/absolute/path/to/pqc/mindc CPU=6 \
  bash signing/polynomial/verify.sh
```

Choose an available CPU. The default mathematical compiler digest is
`c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5`;
PQC compiler digest is
`1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e`.
The wrapper also pins the exact documented LLVM20 executables. A different local
rebuild/profile requires explicit qualification and reviewed pins; silently
substituting a version label is insufficient.

Require process exit zero and the final `POLYNOMIAL_SIGNED_PAYLOAD=PASS` line.
The wrapper pins both public keys, requires signed/deterministic/strict-FP
verification, checks the expected carrier profile and digest with the MIND MAP
binding checker, enforces polynomial release scope, then checks every payload
hash and the exact inventory. A historical K4/K5 carrier/manifest pair is refused
by the scope check even though its signatures remain valid. Exit 1, build errors,
signals or timeouts do not authenticate a release.

The verifier bootstrap is explicit: reviewers must trust the reviewed wrapper
and its fixed hashes, the selected compiler/backend executables, system hashing
and shell tools, OS and hardware. The wrapper stages and hash-checks the three
MIND binding-source files before compiling them; it never executes the repository
Makefile. Merely listing an untrusted verifier inside a signed manifest would be
circular. Running a replaced wrapper is not safe just because that wrapper
prints PASS. The independent review documents this boundary and its controls.

## Project public keys

Use the same dedicated Euler-project public identity as the historical release:

| Algorithm | Public file | SHA-256 of decoded bytes |
| --- | --- | --- |
| ML-DSA-87 | [Hex key](../public-keys/ml-dsa-87.pub.hex) | `0c7f47a456f77dbacbbdd4a5a03328b20543859461dc9c00f49289467a594eb0` |
| SLH-DSA-SHAKE-256s | [Hex key](../public-keys/slh-dsa-shake-256s.pub.hex) | `ac85e7ecbd748a1ab57e67e44ca9b60e490ba7a7786e9ef4c707f790531c1e84` |

Confirm these fingerprints through a separately trusted owner channel. Public
keys are safe to distribute; finding them beside a package alone does not prove
ownership. Private signing seeds remain outside the repository and are never
needed for verification. Both signatures are embedded binary fields; detached
signature files are unnecessary. Reproducing verification is public; re-emitting
the identical signature requires the project private seeds.

## Manifest scope and exclusions

`PAYLOAD_FILES.txt` is the exact sorted relative-path inventory. It includes the
polynomial source, certificates, tests and historical evidence, this audit and
new independent MIND tests, public compiler profiles, NDv1 foundations/dependency
sources, the pinned metadata-binding sources, governance/provenance/license
documents, new verification and control-generation source, and the unchanged
historical manifest/carrier. It is itself bound by the new manifest.

Excluded to avoid self-reference: this directory's `PAYLOAD_SHA256SUMS`,
`package.mic3`, `SHA256SUMS`, and all files below `execution/`. Post-signature
execution/review reports are supporting observations, not recursively signed
claims. This directory's separate `SHA256SUMS` binds the final manifest,
carrier and reports for export integrity. The historical root checksum manifest
retains its original release scope. Unlisted/untracked files are not authenticated.

Both cryptographic signatures and the MIND metadata binding must succeed. They
authenticate package bytes, not the truth of any mathematical statement,
compiler correctness or a soundness metatheorem. The polynomial identities remain
**FORMAL_PROOF_SUBMITTED**; designated acceptance under `PROOF_POLICY.md` is open.
Direct-native qualification remains **BLOCKED**. This does not claim a new
counterexample, new mathematical discovery or progress toward RH.
