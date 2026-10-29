# Pre-execution polynomial provenance controls

Author: STARGA Inc.

Freeze the finalized payload manifest, carrier source, verifier and MIND control
generator before signing or running these cases. Each case uses a separate
scratch copy. Do not change finalized release bytes. Signal, timeout or build
failure is an execution failure, never successful corruption detection.

| Case | Required observation |
| --- | --- |
| Two emissions with the same manifest and project keys | Both exit 0; complete MIC files byte-identical |
| Both public-key pins, signed/strict-FP/deterministic verification | Exit 0, hybrid signatures accepted |
| MIND binding with computed manifest digest | Exit 0, exact PASS line |
| Full public wrapper | Exit 0, every listed file hash and scope/inventory accepted |
| Corrupt first ML-DSA signature byte (offset 440) | Crypto verifier normal exit 1 |
| Corrupt first SLH-DSA signature byte (offset 7760) | Crypto verifier normal exit 1 |
| Change signed digest's first hex byte (offset 355) | Crypto verifier normal exit 1 |
| Wrong ML-DSA public-key pin, correct other pin | Crypto verifier normal exit 1 |
| Wrong SLH-DSA public-key pin, correct other pin | Crypto verifier normal exit 1 |
| Wrong expected digest to MIND binding checker | Normal exit 1, exact FAIL line |
| Append LF to a copied polynomial certificate | Full wrapper normal exit 1 from failed payload hash |
| Change copied bridge source before compilation | Full wrapper normal exit 1 from fixed bootstrap source hash |
| Replace new manifest/carrier by unchanged historical K4/K5 pair | Both cryptographic signatures remain valid, but full wrapper normal exit 1 at polynomial scope enforcement |

The MIND generator first accepts the complete fixed carrier profile with the
binding checker, checks exact length 37642, and emits three separate copies.
Its offsets follow the existing fixed MAP field profile; they are not searched
as arbitrary substrings. It does not assess signatures or theorem truth.

The wrapper's independent pre-signing syntax review also checks duplicate,
absolute, parent-traversal, double-slash and trailing-slash manifest paths.
These are provenance-input checks, not mathematical certificate tests.
