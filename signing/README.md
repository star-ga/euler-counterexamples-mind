# Hybrid PQC package provenance

Author: STARGA Inc.

The two signatures embedded in `package.mic3` authenticate a MIC/MAP carrier
whose `org.starga.package_manifest_sha256` attribute is the SHA-256 digest of
the exact `PAYLOAD_SHA256SUMS` bytes. That manifest, in turn, binds the listed
K4 and K5 source, certificates, test fixtures, evidence and toolchain recipe.
This is an indirect signed-manifest construction; it is not a claim that the
MIC body implements the mathematical checker. The carrier simply returns zero.

Both ML-DSA-87 and SLH-DSA-SHAKE-256s signatures must verify. The complete
signatures are binary fields `signature.mldsa87` (4,627 bytes) and
`signature.slhdsa` (29,792 bytes) in `package.mic3`, alongside the public keys.
Separate detached signature files are unnecessary. The official verifier
checks the canonical signing preimage, including the application attributes.

## Public keys and identity

| Algorithm | Public key | SHA-256 of decoded public-key bytes |
| --- | --- | --- |
| ML-DSA-87 | [Hex key](public-keys/ml-dsa-87.pub.hex) | `0c7f47a456f77dbacbbdd4a5a03328b20543859461dc9c00f49289467a594eb0` |
| SLH-DSA-SHAKE-256s | [Hex key](public-keys/slh-dsa-shake-256s.pub.hex) | `ac85e7ecbd748a1ab57e67e44ca9b60e490ba7a7786e9ef4c707f790531c1e84` |

These are a dedicated STARGA Euler-project signing identity created for this
release, not a previously established organization-wide root. Obtain and
compare these fingerprints through an independently trusted owner channel.
Keys found only beside an artifact prove internal consistency, not ownership.
The hex files have one final LF. Fingerprints hash the decoded 2,592-byte and
64-byte keys, not their hex text. For example:

```sh
xxd -r -p signing/public-keys/ml-dsa-87.pub.hex | sha256sum
xxd -r -p signing/public-keys/slh-dsa-shake-256s.pub.hex | sha256sum
```

Private seeds remain outside the repository with restrictive local permissions.
They were not sent to the independent replay hosts. Creation was not an
air-gapped ceremony, and no hardware key custody is claimed. No private seed,
token or signing environment belongs in a proof bundle or execution receipt.

## Reproduce verification

Use a fresh checkout without another writer. First build the public official
compiler using the [PQC profile](../toolchain/public-pqc/README.md). Its source
and locked dependencies are public. Both `evidence-mldsa` and `evidence-slhdsa`
features are required. The observed binary requires glibc 2.39; on an older
host rebuild in a compatible environment. Its version label alone is not a pin.

Build the MIND metadata checker with either documented mathematical compiler
profile. From the repository root:

```sh
make signed-verify \
  MINDC=/absolute/path/to/mathematical/mindc \
  MINDC_SHA256=a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa \
  PQC_MINDC=/absolute/path/to/pqc/mindc \
  PQC_MINDC_SHA256=1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e
```

The separately qualified public mathematical compiler hash is
`c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5`.
If rebuilding produces a different compiler hash, investigate and record that
build explicitly instead of silently replacing either historical pin.

The target authenticates the frozen carrier with both full public-key pins,
requires strict FP and deterministic metadata, computes the manifest digest,
runs the [MIND MAP binding checker](map-binding/README.md), and verifies every
listed file. It stops on failure. Both cryptographic authentication and MIND
binding acceptance are necessary; neither alone proves the package authentic.
Use the separately selected key fingerprints above before trusting the target.
The compiler's JSON can report internally valid signatures even when the
trusted-key allowlist rejects them. Always require process exit zero in
addition to any JSON fields; the Make recipe does so.
The recipe removes `MIND_EVIDENCE_VERIFY_PUBKEYS` from the verifier environment
so inherited extra trust anchors cannot widen its two explicit key pins.

`PAYLOAD_SHA256SUMS` is exhaustive for tracked release files except itself,
`signing/package.mic3`, files under `signing/execution/`, and every file named
`SHA256SUMS`. Those exclusions avoid self-reference and permit recording the
result of verifying the completed signature. The excluded execution reports
are supplementary observations, not signed claims. The root `SHA256SUMS`
covers all tracked files except itself, including the signature and reports.
Extra untracked files are outside this package; do not execute them as part
of its reproduction procedure.

## Reproducibility and trust boundary

Anyone can reproduce verification using only the public keys and public
source. Producing this same signature again requires the project private
seeds. The owner's repeated signing check compares complete artifact bytes;
third parties need not possess the seeds to reproduce verification results.
Byte-identical compiler builds on all systems are not claimed. Native proof
executables and outputs have separately documented comparisons.

For the authorized owner, with the two private seed variables configured
securely outside the checkout, the exact emission command is:

```sh
digest=$(sha256sum signing/PAYLOAD_SHA256SUMS | cut -d ' ' -f1)
"$PQC_MINDC" signing/carrier.mind --emit-evidence signing/package.mic3 \
  --evidence-attr "org.starga.package_manifest_sha256=$digest" \
  --evidence-attr org.starga.attestation_scope=package-provenance
```

The configured variable names are `MIND_EVIDENCE_MLDSA87_KEY` and
`MIND_EVIDENCE_SLHDSA_KEY`. Do not put their values in command arguments,
shell history, CI output or repository files. Public verification requires
neither variable. Re-emission to a second output followed by `cmp` is the
owner's deterministic-signature control; it is not required of reviewers.

Signature verification uses the official compiler and its cryptographic
libraries. The additional MIND checker strictly validates the carrier body,
MAP field names, types, ordering, lengths, exact EOF and manifest-digest value.
Shell/Make and SHA-256 tools provide orchestration and file hashing. These are
explicit provenance dependencies, not substitutes for the mathematical kernel.

Cryptographic provenance does not establish mathematical truth, source-to-ELF
equivalence or kernel soundness. Both candidate derivations remain
`FORMAL_PROOF_SUBMITTED`; independent validation required by
[PROOF_POLICY.md](../PROOF_POLICY.md) remains open. See `execution/RESULTS.md`
for the actual final-artifact verification, tampering and replay observations.
