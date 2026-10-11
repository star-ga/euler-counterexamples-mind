# Independent final package-provenance verification

Verdict: **PASS for the tested integrity and release-scope contract**, with the
bootstrap assumptions and limitations below. This review grants no mathematical
approval. `FORMAL_PROOF_SUBMITTED` and direct-native `BLOCKED` remain unchanged.

The exact frozen polynomial artifact passed the reviewed public wrapper in an
independently staged payload copy. Both requested negative controls returned
ordinary exit 1 at the intended guard. All 1,506 historical payload hashes passed
in a complete historical snapshot. Signed repository files were not edited.

## Frozen identities

| Item | SHA-256 |
| --- | --- |
| Polynomial `package.mic3`, 37,642 bytes | `3c5b3aaa32f9e638c2e641ff276e1791c61bcb14d61a78b524da60695a3b57d4` |
| Polynomial `PAYLOAD_SHA256SUMS`, 2,580 files | `35d466ce039a8c031fb0ea6df912cd7dda17855174faec1cd63e0b798fd1cdd8` |
| Reviewed polynomial `verify.sh` | `9754e8945992555de32f0a4ee7927f4c8f1a427cc7c8a05212fe5f27498b7107` |
| Mathematical compiler | `c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5` |
| Signing-enabled compiler | `1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e` |
| Historical `signing/package.mic3` | `aade52f3d0c3ad874ff7c25113f423f487c0579e864cf71ddf1833618ba86918` |
| Historical `signing/PAYLOAD_SHA256SUMS` | `d3471291b15b9e3f6d43860d4525729098c628472f7812611c2ae522a1d83965` |

The wrapper's decoded public-key fingerprints were checked, and the same keys
were present in the authenticated verifier output:

- ML-DSA-87: `0c7f47a456f77dbacbbdd4a5a03328b20543859461dc9c00f49289467a594eb0`.
- SLH-DSA-SHAKE-256s: `ac85e7ecbd748a1ab57e67e44ca9b60e490ba7a7786e9ef4c707f790531c1e84`.

These fingerprints identify the verified public identity. Their association with
the project owner still relies on the supplied trusted pins; colocating public
keys with a package alone would not establish that association.

## Procedure, exact commands, and results

The working root was `/work/audit/independent-signature-review`. Its
`public-base` snapshot contains each manifest-listed file copied byte-for-byte
from the frozen repository plus the new carrier and manifest. The list had 2,580
unique, sorted paths and no symlinks. Separate copies were prepared for each
negative control before execution. `PREEXECUTION_CASES.tsv`, `PREEXECUTION.sha256`,
and `evidence/frozen-inputs.sha256` record expectations and control inputs.

`run-wrapper.sh` records the complete wrapper invocations. For each of
`public-base`, `public-old-substitution`, and `public-bridge-change`, it ran:

```bash
env -i PATH=/usr/bin:/bin LANG=C LC_ALL=C \
  MINDC=/work/compiler/math/mindc \
  PQC_MINDC=/work/compiler/pqc/mindc CPU=7 \
  timeout 180 taskset -c 7 nice -n 19 \
  /usr/bin/time -v -o evidence/CASE.time \
  bash CASE/signing/polynomial/verify.sh \
  > evidence/CASE.stdout 2> evidence/CASE.stderr
```

Here `CASE` is the corresponding directory name, expanded by the saved script.
Exit status was captured immediately in the matching `.exit` file. No ambient
compiler-hash override or verification-key environment variable was supplied.
The unchanged wrapper additionally caps its build at 1 GiB/50 CPU seconds/60 wall
seconds and verification calls at 256 MiB/20 CPU seconds/30 wall seconds.

| Case | Exit | Observed decisive result |
| --- | --- | --- |
| Exact new polynomial package | 0 | Authenticated hybrid signature, MIND binding PASS, all 2,580 file hashes and exact inventory PASS |
| Copied historical carrier plus historical manifest substituted into new polynomial slots | 1 | Historical hybrid authentication and MIND binding PASS; polynomial required-scope guard refuses; no final PASS |
| Changed `bridge.mind` with exact new wrapper | 1 | `src/bridge.mind: FAILED`; source-pin guard refuses before compilation |
| Historical hashes in incomplete polynomial-only snapshot | 1 | 458 legacy-only files absent from that snapshot; staging failure, not an integrity finding |
| Historical hashes in complete historical snapshot | 0 | All 1,506 historical hashes PASS |

The exact new-package stdout ends:

```text
POLYNOMIAL_SIGNED_PAYLOAD=PASS
```

Its JSON verification record reports `signature` as
`pqc-hybrid-ml-dsa-87-slh-dsa-256s`, `provenance_authenticated: true`,
`trace_hash_valid: true`, `fp_mode: strict`, and `determinism: deterministic`.
The MIND metadata checker prints `MAP_DIGEST_BINDING=PASS`. Full JSON, all file
hash lines, compiler status lines, and stderr are retained, not replaced by this
summary. `evidence/crypto-summary.json` extracts the relevant public fields.

The historical substitution changed only these two scratch files:

```bash
cp public-old-substitution/signing/package.mic3 \
   public-old-substitution/signing/polynomial/package.mic3
cp public-old-substitution/signing/PAYLOAD_SHA256SUMS \
   public-old-substitution/signing/polynomial/PAYLOAD_SHA256SUMS
```

Both are valid historical artifacts, so cryptographic verification and digest
binding legitimately pass. The unchanged wrapper's required paths at lines
54–63 include polynomial source/certificates/audit/control files absent from the
historical manifest; the awk END guard at line 72 returns 1 before payload
acceptance. This confirms that historical K4/K5 authenticity is not accepted as
polynomial release coverage. No crash, timeout, or compiler failure was involved.

The bridge control appended only the following ASCII bytes in its scratch copy:

```text
\n// Independent pinned-source integrity negative control.\n
```

The wrapper still had the trusted digest above. Its staged source-hash check
reported `src/bridge.mind: FAILED` and normal exit 1; build and cryptographic
verification were never reached. The source mutation would not alter executable
semantics, making this a precise test of byte pinning rather than behavior.

The first historical check attempted all legacy entries in the polynomial-only
snapshot and failed because 458 historical-only files were not part of the new
payload. Its raw failed receipt remains. A separate snapshot then copied exactly
all 1,506 historical entries from the unchanged repository, plus its manifest
and carrier, and ran:

```bash
(cd public-historical && sha256sum -c signing/PAYLOAD_SHA256SUMS) \
  > evidence/historical-complete.stdout 2> evidence/historical-complete.stderr
```

That command returned 0; stdout has every historical entry marked OK and stderr
is empty. Carrier/manifest hashes match the original preserved historical pins.
This distinguishes an incomplete staging attempt from a successful preservation
check and from an actual payload mismatch.

The new-package run used 1.21 seconds wall time and 108,728 KiB maximum RSS;
historical substitution 1.20 seconds and 108,640 KiB; bridge change 0.18 seconds
and 8,200 KiB. These are process observations, not cryptographic benchmarks.
Both successful package verification and historical substitution have empty
stderr; the bridge control stderr contains the checksum mismatch warning.

## Source, scope, certificate and output binding

The exact wrapper was read before execution. It pins the mathematical and PQC
compiler digests, both decoded public keys, all three MIND binding source files,
and all three LLVM20 tool binaries before compiling the binding checker. It does
not execute an unauthenticated repository Makefile. Trusted wrapper acquisition
is an explicit bootstrap requirement, not inferred from its own manifest entry.

The MIND binding source was read in full. `bridge.mind` requires the fixed carrier
body, exact 13-key canonical metadata profile, package-provenance scope, expected
64-character manifest digest, expected hybrid signature-field lengths, and exact
EOF. It does not itself verify signatures; the unchanged wrapper verifies the
same frozen carrier bytes first using the pinned cryptographic compiler.

The new manifest has 2,580 unique sorted canonical paths. The wrapper validated
every payload digest and compared the parsed list with the bound
`PAYLOAD_FILES.txt`. Required polynomial source, both primary certificates,
case inventory, audit reports, output receipts and control sources are present.
Selected independently read hashes are retained in
`evidence/selected-payload-identities.sha256`, including:

- Kernel: `7eed71f7cb06715744471edf80da5b6b1f3cdadb2ba345e3605814d2951fa3e2`.
- Binomial certificate: `dd5b0dae2eaa000c04f435fb0a196c57fd0ce1bc58f9ad5be661c77297bb1553`.
- Scaled K4 certificate: `cb48461b46ebde6796993c45109f5e46bd2c30e71f063794a54b9d1259dd01a1`.
- Corpus result table: `658c9d7d6e8a89fcf833ef980a814b8adeac29c3d80371953e71416a09030b8f`.
- Independent MIND harness: `07a311845f4ef2f14d2cc28c63e5de58745ac093169caffb55db60cb37c3437a`.
- Its fresh-run stdout: `252153e3de83ecfba869e2d2c9dd5c67ca10569dcc22ba4184f7c89eaa1c6b3d`.

Scope inspection found no self-referential inclusion of the new carrier,
manifest, final checksum file, or `signing/polynomial/execution/`. This review
and later execution reports therefore remain supporting observations outside
the signed payload. Authentication covers the listed bytes, not arbitrary
unlisted files or later additions.

## Secret-material check and limitations

The 2,580 signed files were scanned for sensitive private-key/seed/credential
filenames, PEM private-key markers and selected recognizable access-token
prefixes. No matches were found; `evidence/scope-secret-scan.json` records the
scope and empty results. Public-key hex files are intentionally present and
match the decoded fingerprints above. No signing seed or private key was read
or used in this verification.

This pattern-based check cannot prove the absence of arbitrary encoded secrets.
This review also does not independently reimplement either signature scheme or
prove compiler, hashing utilities, OS or hardware correctness. It depends on
the supplied trusted pins, official compiler behavior, immutable scratch inputs,
and the standard system-tool execution environment. Root-owned signature-bit
corruption and wrong-pin controls are separate evidence and are not claimed as
executed here. No source, signed payload, signature, or proof-status mutation was
made in the repository by this review.
