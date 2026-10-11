# Independent signature controls

Author: STARGA Inc.

All nine prelisted controls produced their expected normal exit codes. This is cryptographic integrity and key-pinning evidence. It does not approve a mathematical proof, validate the kernel's soundness, or establish native-executable equivalence.

The signed diagnostic fixture has SHA-256 `0f941b637d620ef4d9aac6ea38c8f362df492a43c91b53536fb28a48436854f4` and MIC3 revision0x02. It was produced separately before this review. Its signed application fields contain scope `package-provenance` and a diagnostic manifest digest `8f240f949d9e45b3efe4c8ef8624900dee02af88811db10d5b0195529aef3926`. This fixture is not the public release's signature. The included .pub.hex files contain only public verification keys; the .wrong.pub.hex files are one-hex-digit negative controls. No private signing key was read, copied or distributed by this review lane.

The exact prelist, inputs and mutations were frozen before verifier execution. `receipts/SIGNATURE_PRELIST.json` SHA-256 is `40ec52b134076a6a4ff60df49b713c0dae87e0c8c62fce5efccf6ea300537f8e`. The prelist lists all input hashes and exact mutated byte offsets. Signature and attribute flips each change one byte without altering wire lengths; each removed-signature fixture preserves all other MAP entry bytes and updates the entry count. Fixture generation is an external diagnostic instrument, not mathematical or signature authority.

| Case | Expected / observed exit | Observed signature result |
|---|---:|---|
| Correct artifact and both correct key pins | 0 / 0 | Valid two-leg hybrid; provenance_authenticated=true |
| Wrong ML-DSA-87 pin; correct SLH-DSA pin | 1 / 1 | Trust allowlist refusal |
| Correct ML-DSA-87 pin; wrong SLH-DSA pin | 1 / 1 | Trust allowlist refusal |
| One byte changed in ML-DSA-87 signature | 1 / 1 | Invalid signature |
| One byte changed in SLH-DSA signature | 1 / 1 | Invalid signature |
| One hexadecimal digit changed in manifest digest | 1 / 1 | Invalid signature |
| One byte changed in attestation scope | 1 / 1 | Invalid signature |
| ML-DSA-87 signature field removed | 1 / 1 | Malformed signature |
| SLH-DSA signature field removed | 1 / 1 | Malformed signature |

Every case retains a valid MIC3 trace hash and valid SSA. The six artifact mutations therefore exercise the signature/MAP binding rather than a changed body hash. Every rejection exits normally with1; no timeout, signal, crash, or build failure is counted as detection. Raw per-case stdout, stderr and exit files are retained, together with input and output hashes in the prelist and observations receipt.

## Required exit-code gate

The wrong-key-pin controls expose a reporting limitation: JSON still reports `provenance_authenticated=true` and the cryptographically valid scheme even when the pinned-key allowlist fails. The process correctly exits1 and explains the refusal on stderr. Consumers must require exit0 and the expected scheme/key policy; accepting the JSON boolean alone is unsafe. The boolean records internal signature consistency and must not replace successful trust-policy evaluation.

## Replaying the controls

Build the verifier using README.md, then run from this directory's fixtures subdirectory:

```sh
/path/to/mindc verify --json --require-signed \
  --signer-pubkey "$(cat ml-dsa-87.pub.hex)" \
  --signer-pubkey "$(cat slh-dsa-shake-256s.pub.hex)" signed.mic3
```

For the two pin controls, substitute exactly one corresponding `.wrong.pub.hex` file. For the remaining controls use both original public pins and the artifact filename listed in `receipts/SIGNATURE_PRELIST.json`. Preserve the verifier's actual exit code before inspecting or piping its output. The matching compiler digest is `1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e`; independently rebuilt compiler bytes may differ and require their own qualification.

Each local verifier invocation used one CPU, nice19,1GiB address-space limit,10CPU seconds and15wall seconds, with an empty environment apart from PATH and the C locale. Verification keys came from the supplied public-only files. No private credentials or environment-provided trust keys were inherited.

## Receipt paths

Case verification actually ran from the fixture directory with relative artifact filenames, so raw JSON stdout already contains canonical names such as `signed.mic3`; these outputs are unmodified. Build-hash receipts replace local workspace prefixes with `PROFILE/`, `PUBLIC_SOURCE/` and `RUST_TOOLCHAIN/`, preserving each digest exactly. These are explicit path labels for the documented profile, pinned public source and Rust installation, not literal absolute paths. The raw originals remain in the private operational handoff. Host names, addresses, access routes and credential locations are excluded from this public directory.
