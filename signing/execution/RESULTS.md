# Final hybrid-signed package: observed results

Author: STARGA Inc.
Date: 2026-10-11

The final package-provenance artifact was emitted successfully with both
configured project signing keys. The artifact and manifest identities are:

| Item | Identity |
| --- | --- |
| Manifest | `PAYLOAD_SHA256SUMS`, 199,433 bytes, 1,506 listed files |
| Manifest SHA-256 | `d3471291b15b9e3f6d43860d4525729098c628472f7812611c2ae522a1d83965` |
| Signed carrier | `package.mic3`, 37,642 bytes |
| Carrier SHA-256 | `aade52f3d0c3ad874ff7c25113f423f487c0579e864cf71ddf1833618ba86918` |
| Signing/verifying compiler SHA-256 | `1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e` |
| Scheme | `pqc-hybrid-ml-dsa-87-slh-dsa-256s` |

Both signatures are embedded in the MIC/MAP carrier. The source/configuration
recipe for the official compiler is public in `toolchain/public-pqc/`.
The mathematical compiler pin and all 88 protected K4 files remain unchanged.

## Final-artifact checks

| Check | Observed outcome |
| --- | --- |
| First emission and second emission, identical inputs/keys | Both exit 0; complete artifact bytes identical |
| Full two-key-pinned verification, strict FP, deterministic metadata | Exit 0, valid hybrid, empty stderr |
| Corrupt ML-DSA-87 signature | Normal exit 1 |
| Corrupt SLH-DSA signature | Normal exit 1 |
| Change signed manifest-digest attribute | Normal exit 1 |
| Wrong ML-DSA key pin, other key correct | Normal exit 1 |
| Wrong SLH-DSA key pin, other key correct | Normal exit 1 |
| MIND metadata binding, computed final manifest digest | Exit 0, `MAP_DIGEST_BINDING=PASS`, empty stderr |
| MIND metadata binding, wrong expected digest | Normal exit 1, `MAP_DIGEST_BINDING=FAIL`, empty stderr |
| Append LF to a copied K5 certificate; check final manifest | Normal exit 1, exactly that file fails its hash |
| Root `make signed-verify` using qualified public compiler profiles | Exit 0; both-key verification, native binding, all 1,506 file hashes pass |

The final six cryptographic cases were listed and input-hashed before execution
in FINAL_CONTROL_PRELIST.json. Their actual outputs and exit values are retained
alongside it. The three binding/payload cases likewise have a separate frozen
prelist. Mutated files existed only in an isolated scratch tree. Source and
certificate corruption was not applied to the release checkout.
Both removed-signature cases and modified-scope rejection were also exercised
in the separate nine-case diagnostic campaign; see
`toolchain/public-pqc/SIGNATURE_CONTROLS.md`. A timeout or crash is never counted
as a successful rejection. Wrong-pin JSON can still report internal signature
validity, so every consumer must require process exit zero.

## Independent execution and review

A separate automated reviewer checked the exact manifest path set against the
tracked inventory, all 1,506 hashes, all 88 protected hashes, both public-key
fingerprints, and disclosure/status boundaries. That reviewer independently ran
the final crypto and MIND-binding commands with a clean environment; both
exited zero with empty stderr. Its findings are in FINAL_PAYLOAD_REVIEW.md.
This is release validation, not authorized mathematical soundness acceptance.

A separate verification lane replayed the final artifact on another physical
machine, using only public files and the same pinned verifier and MIND checker.
Both hosts produced byte-identical crypto stdout, binding stdout, empty stderr
and exit-zero files. Their manifest digests matched independently.

- Crypto stdout SHA-256: `2243b01132a0f705af24c7b75c126c002029ee5b287340f9726a5bb6bac588aa`.
- MIND binding stdout SHA-256: `b8a85d0af6dc67cf372e5e0828bc409b31aa064018a9761309d0036c259d4e5f`.
- OOM-kill counters: Host A 1 before/after; Host B 0 before/after.

This is independent-machine execution of transferred pinned binaries, not a
second cryptographic implementation or a second source build. The private
seeds remained on the signing host and were not supplied to either reviewer.
The independent lane's complete receipts are under `independent/`.

## Reproduction and limits

Follow `signing/README.md` for public verification, full key fingerprints and
exact emission syntax. Signing used one CPU, nice 19, a 1 GiB address-space
cap, 80 CPU seconds and 90 wall seconds. Both successful emissions completed
well inside those limits. The earlier unoptimized diagnostic signer reached
its resource timeout without producing an artifact; it is not a successful
signing observation. The public optimized profile supplied the successful run.

Make stdout replaces operational paths by `/PUBLIC_REPO`, `/PUBLIC_COMPILER`,
`/PQC_COMPILER` and `/FROZEN_SNAPSHOT`. Cryptographic-control JSON uses actual
relative fixture names. No private-key values occur in these receipts.
These post-signing reports are deliberately excluded from the signed payload
to avoid self-reference; the root release checksum manifest covers them.

The signatures authenticate package bytes under the selected project identity.
They do not validate inference rules, establish mathematical novelty, prove
compiler correctness or grant `NATIVE_VERIFIED`. Both K4 and K5 remain
`FORMAL_PROOF_SUBMITTED`, with authorized independent kernel validation open.
