# Pre-execution contract — EULER-PQC-MAP-BINDING/1

Author: STARGA Inc.

This parser is not a signature verifier or theorem authority. Positive fixtures
contain structurally sized, synthetic signature slots and must NEVER be used as
cryptographic certificates. Actual authentication must first pass the separate
official `mindc verify --require-signed --signer-pubkey KEY1 --signer-pubkey KEY2`
command. Both stages must consume the same frozen, fully read bytes; use a private
snapshot directory with no concurrent writer and independently pin both public
keys. Digest comparison does not authenticate a stand-alone unsigned input.

Profile: complete exact35-byte carrier body, MAP marker, count13 minimal ULEB;
exact sorted keys and typed values specified in src/bridge.mind. Two app fields:
`org.starga.attestation_scope=package-provenance` and
`org.starga.package_manifest_sha256`, exactly64 lowercase hex. Six evidence fields
and five production hybrid signature fields. No parent, collapse receipts,
unknown keys, duplicates or trailing bytes. Expected digest on fd3 is exactly
64 lowercase hex followed by LF. Input<=131072 bytes, work>=16 bytes.

Tests fixed before execution:

- P01 canonical synthetic slots and zero digest: accept binding only.
- P02 all-f digest and matching expected digest: accept binding only.
- P03 changed signature-slot bytes with unchanged digest: accept binding only
  (deliberately demonstrates that this checker does not authenticate signatures).
- N01 wrong expected digest; N02 expected length64; N03 expected length66;
  N04 uppercase expected; N05 nonhex expected; N06 expected final non-LF.
- N07 changed MIC body; N08 body truncated; N09 bad magic; N10 bad version;
  N11 missing MAP sentinel; N12 zero count; N13 count12; N14 count14;
  N15 nonminimal entry count.
- N16 duplicate metadata key; N17 out-of-order keys; N18 unknown key;
  N19 digest Bytes rather than String; N20 digest63; N21 digest65;
  N22 uppercase artifact digest; N23 nonhex artifact digest; N24 wrong scope;
  N25 wrong schema; N26 wrong substrate; N27 wrong toolchain;
  N28 wrong trace hash; N29 wrong trace-hash kind; N30 signature wrong tag;
  N31 signature short; N32 wrong scheme; N33 missing final key;
  N34 truncated last byte; N35 trailing byte; N36 appended second MAP;
  N37 huge key length; N38 nonminimal value length; N39 nonminimal key length.
- N40 null input; N41 negative input length; N42 input over cap;
  N43 null expected; N44 undersized workspace; N45 null workspace.
- N46 unsigned genuine carrier from official emitter (count8): reject.
- Bounded truncation sweep: every offset0..419 and each signature-field start,
  midpoint and end, excluding complete input. Every proper prefix must reject.
- Restore P01 after all mutation/truncation cases: accept.

Actual checker mutants, compiled and run separately:

- M01 delete expected-digest comparison. P01 remains accepted; N01 becomes
  accepted. The full unchanged suite must exit1 and identify N01 as unexpected.
- M02 delete final EOF check. P01 remains accepted; N35 becomes accepted.
  The full unchanged suite must exit1 and identify N35 as unexpected.

Build failure, timeout, crash or exit2 is never a successful mutation result.
All executable fixture construction, tests and binding decisions are MIND.
Shell only assembles, invokes tools, captures receipts and hashes public files.
