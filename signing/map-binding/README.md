# EULER-PQC-MAP-BINDING/1

Author: STARGA Inc.

This small MIND checker binds a package-manifest digest to one precisely scoped
MIC/MAP carrier. It is an auxiliary provenance checker, not a cryptographic
signature verifier, a theorem checker or a new proof authority. It applies to
the Euler counterexamples package; the mathematical kernel, K4 certificate and
historical compiler pin were not edited by this work.

## Consumer contract

1. Work on one frozen snapshot containing the carrier, payload manifest and
   payload files. No other writer may change it between verification steps.
2. Authenticate that exact carrier with a separately qualified, signing-enabled
   official compiler. Require the production hybrid and independently selected
   full ML-DSA-87 and SLH-DSA public keys. Both keys belong in the allowlist.
3. Recompute all payload-file hashes against the intended manifest. Recompute
   SHA-256 of the exact manifest bytes and write its 64 lowercase hex digits plus
   one LF to `expected-digest.txt`.
4. Run this checker on the same complete carrier bytes and that expected digest.
   All preceding commands and the checker must succeed. A stand-alone
   `MAP_DIGEST_BINDING=PASS` is NOT a signature or mathematical proof claim.

Example orchestration (run only with selected public keys and frozen files):

```sh
set -euo pipefail
"$SIGNING_ENABLED_MINDC" verify package-provenance.mic3 --require-signed \
  --signer-pubkey "$MLDSA87_PUBLIC_HEX" --signer-pubkey "$SLHDSA_PUBLIC_HEX"
sha256sum -c PAYLOAD.sha256
sha256sum PAYLOAD.sha256 | cut -d ' ' -f 1 > expected-digest.txt
./map-binding-check < package-provenance.mic3 3< expected-digest.txt
```

The caller must stop on any failure; shell commands are orchestration and file
hashing only. The official crypto verifier is in this provenance TCB. No
Python/Rust/Lean runtime was introduced into the MIND checker or test decisions.
The parser-only campaign did not sign artifacts or use private keys. The
completed package signing campaign is recorded separately in
`../execution/RESULTS.md`; these synthetic tests alone do not establish it.

## Exact parser boundary

The first 35 bytes must equal `reference/carrier-body.mic3`, whose SHA-256 is
`f59773d526008bf435f985b1c4f66c28817b709e0f6c509f0f73d0189c45e13f`.
That is the complete canonical body of `reference/carrier.mind`; it is a minimal
package-provenance carrier, not a serialization of the mathematical kernel.
This byte comparison fixes the MAP boundary at offset 35. The checker never
searches for sentinel/key substrings in arbitrary bytes and never accepts a
caller-supplied offset.

The sentinel is 0x4D followed by exactly 13 entries, in this order:

| Key | Required type/value |
| --- | --- |
| evidence_chain.determinism | String `deterministic` |
| evidence_chain.schema | Int 1, minimal ZigZag/ULEB encoding 2 |
| evidence_chain.substrate | String `cpu` |
| evidence_chain.toolchain | String `0.10.2` |
| evidence_chain.trace_hash | Bytes, length 32, exact carrier-body hash |
| evidence_chain.trace_hash_kind | String `mic3-bytes` |
| org.starga.attestation_scope | String `package-provenance` |
| org.starga.package_manifest_sha256 | String, length 64, exact expected lowercase digest |
| signature.mldsa87 | Bytes, length 4627 |
| signature.mldsa87_pubkey | Bytes, length 2592 |
| signature.scheme | String `pqc-hybrid-ml-dsa-87-slh-dsa-256s` |
| signature.slhdsa | Bytes, length 29792 |
| signature.slhdsa_pubkey | Bytes, length 64 |

All counts/lengths are minimal ULEB128 bounded by 131072; the only Int is schema 1.
Exact field order and names enforce uniqueness. Unknown/additional fields,
different types, malformed lengths, truncation and trailing data are rejected.
The complete carrier is capped at 128 KiB. fd3 must contain exactly 65 bytes.

The official compiler's signature preimage includes non-signature MAP
application fields, so successful trusted-key verification authenticates the
digest claim. This checker compares that claim against the independently
computed manifest digest. It cannot prove that a signer inspected the payload,
that its assertions are true, or that the mathematical kernel is sound.

This deliberately narrow profile refuses different carriers, toolchain labels,
parents, collapse receipts or extra attributes. Such changes require an explicit
profile update and tests; no permissive fallback exists.

## Observed qualification

Built with official compiler SHA-256
`a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa`,
explicit MLIR CPU lowering and LLVM 20.1.8. This checker build does not need PQC
features; the separate signature verifier does.

- Checker and baseline suite build: exit 0.
- Baseline suite: exit 0, empty stderr, 4 positive controls and 477 expected
  rejections (46 named and 431 proper prefixes), restored positive accepted.
- CLI: synthetic matching carrier exit 0; wrong digest, trailing data and genuine
  unsigned carrier each exit 1, with empty stderr and explicit FAIL output.
- M01 removes digest comparison: build exit 0; suite terminates normally with exit 1, observes
  acceptance of N01 wrong expected digest (also N22/N23), retains all positives.
- M02 removes EOF check: build exit 0; suite terminates normally with exit 1, observes acceptance
  of N35 trailing byte and N36 second MAP, retains all positives.

Mutant suite exit 1 is its expected report of a caught checker defect. It is not
a crash or cryptographic refusal. Both mutants and their exact diffs are retained.

All signature slots used by these parser tests are synthetic and invalid as
cryptographic signatures. P03 intentionally changes a signature byte while
remaining structurally accepted, demonstrating the separate authority boundary.
These runs do not claim a completed signed-package end-to-end verification.

The first build failed because both test and CLI `main` functions were under
the same project src directory. It was corrected by isolated suite staging;
the failed receipt and all test-contract adjustments are preserved.

Each build used one CPU and a 1 GiB address-space limit; each run used one CPU
and 256 MiB. Peak successful build RSS was 110768 KiB; peak run RSS was 8180 KiB.
All measured runs reported 0 swaps; global oom_kill stayed 1. Raw outputs, exits, timings and
hashes are under `receipts/`. Commands are in `COMMANDS.txt`.
