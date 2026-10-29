# Polynomial provenance: observed execution

Author: STARGA Inc.
Date: 2026-10-11

This report records the new polynomial package, not a replacement of the
historical K4/K5 attestation. It is outside the signed payload to avoid a
self-referential signature claim; the adjacent final checksum manifest covers it.
The 2026-10-11 carrier below was superseded on 2026-10-28 by a re-emission over a
corrected manifest; see the amendment at the end for the current hashes.

| Artifact | SHA-256 |
| --- | --- |
| New 2,580-file manifest | `35d466ce039a8c031fb0ea6df912cd7dda17855174faec1cd63e0b798fd1cdd8` |
| New 37,642-byte hybrid carrier | `3c5b3aaa32f9e638c2e641ff276e1791c61bcb14d61a78b524da60695a3b57d4` |
| Reviewed public wrapper | `9754e8945992555de32f0a4ee7927f4c8f1a427cc7c8a05212fe5f27498b7107` |
| Unchanged historical carrier | `aade52f3d0c3ad874ff7c25113f423f487c0579e864cf71ddf1833618ba86918` |
| Unchanged historical manifest | `d3471291b15b9e3f6d43860d4525729098c628472f7812611c2ae522a1d83965` |

The approved public-source PQC compiler has SHA-256
`1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e`.
Both project seed variables were read privately for emission; no seed was
included in command arguments, artifacts, public receipts or the repository.
The public keys and decoded-byte fingerprints remain unchanged.

## Final controls

| Control | Observed result |
| --- | --- |
| Two emissions, same payload/keys | Both exit 0; 4.353s and 4.256s; complete bytes identical |
| Both-key-pinned hybrid verification, strict FP and deterministic metadata | Exit 0 |
| MIND digest binding, exact manifest digest | Exit 0; `MAP_DIGEST_BINDING=PASS` |
| Full public wrapper | Exit 0; all 2,580 hashes and scope/inventory pass; empty stderr |
| MIND control generator | Exit 0; emits three changed copies |
| Change ML-DSA signature byte | Normal crypto exit 1 |
| Change SLH-DSA signature byte | Normal crypto exit 1 |
| Change signed manifest-digest byte | Normal crypto exit 1 |
| Wrong ML-DSA pin, correct SLH-DSA pin | Normal crypto exit 1 |
| Wrong SLH-DSA pin, correct ML-DSA pin | Normal crypto exit 1 |
| Wrong expected manifest digest | Normal binding exit 1; `MAP_DIGEST_BINDING=FAIL` |
| Append LF to copied polynomial certificate | Normal wrapper exit 1; exactly that payload hash fails |

The test contract and final input hashes were fixed before execution. Three
changed carriers came from the committed MIND generator after it checked the
complete fixed carrier shape. No signal, timeout or build failure was counted
as a successful refusal. Wrong-pin JSON may still report internal signature
validity; the nonzero process status is decisive. Raw observed status values,
streams, input hashes and the transport command script are retained in `controls/`.

An independent verification lane additionally ran the full wrapper, rejected
a modified bootstrap bridge before compilation, and rejected the unchanged old
K4/K5 carrier/manifest presented as polynomial coverage. The latter still passes
cryptographic verification and MIND digest binding, then fails the required
polynomial scope check. Its detailed report and receipts are under `independent/`.
These tests validate provenance behavior, not mathematical soundness.

## Bootstrap findings and trust

Pre-signing independent review identified two issues in the initial draft wrapper:
compiling a not-yet-authenticated binding checker, and accepting a valid older
manifest without checking polynomial coverage. The final wrapper uses fixed
source hashes before compilation and a canonical, unique, scope-constrained
manifest inventory. Duplicate, absolute, parent, repeated-slash and trailing-slash
paths fail. See the signed [review](../../../audits/polynomial-20261011/PROVENANCE_REVIEW.md)
for exact source references, attempted cases and fixes.

The trusted bootstrap remains the independently obtained/reviewed wrapper,
its pins, the selected official compilers/backend, hash/shell utilities and host.
An attacker replacing that trusted wrapper is outside these checks. Historical
K4/K5 verification instructions remain byte-identical; this new hardened wrapper
does not retroactively change them or qualify arbitrary untrusted verifier code.
The historical carrier and all 1,506 bound payload files independently still hash
correctly. Private signing material never entered either verification snapshot.

## Additional development checks

Arch-Mind's optional reference gate passed on 35 MIND source files and 268
reflected declarations. Its Python reference instrumentation remains a separate
development aid, not theorem authority or a runtime dependency of these MIND
proof checks. The staged 3,148-file private-seed scan found zero matches for the
actual seed values as hex, uppercase hex or raw bytes. This is a specific secret
exposure check, not a guarantee that every possible secret pattern was detected.
No key file, compiler executable, build cache or private research history is added.

Receipt export only normalizes operational paths; `EXPORT_FILES.tsv` records
original/exported hashes. Sign-emission status is normally written to stderr;
that successful status text is retained. Recorded compiler-build status on stdout
is also retained. The new unsigned `audits/.gitattributes` preserves the trailing
argv separator in command receipts; it changes no source, receipt or signature byte.

The signatures authenticate this scoped release under the project identity.
They do not establish a soundness metatheorem, designated-verifier approval,
mathematical novelty or RH progress. **FORMAL_PROOF_SUBMITTED** and direct-native
**BLOCKED** remain unchanged.

## Amendment 2026-10-28: contract redaction and re-signing

One out-of-scope sentence in the audit contract that referred to unrelated
private work was removed; the audit scope, method and conclusions are unchanged.
`audits/polynomial-20261011/EXPORT_FILES.tsv` records the original and exported
contract hashes, and `FROZEN.sha256` keeps the pre-execution hash as a historical
receipt. The contract, that export map, the audit report and the audit
`SHA256SUMS` are signed payload files, so the manifest was regenerated and the
carrier re-emitted with the same project keys, carrier source and owner emission
command. The path inventory and the 2,580-file count are unchanged.

| Artifact | SHA-256 |
| --- | --- |
| Current 2,580-file manifest | `a16efe4f3dfa0df6d097bf7e8a52fd9a358f76c74c6238fb56a3b85ba3acb944` |
| Current 37,642-byte hybrid carrier | `6323f07d69ee13f0ea497ea65479be63abcd08d03300d9fe7d062032a4bcccd0` |
| Superseded 2026-10-11 manifest | `35d466ce039a8c031fb0ea6df912cd7dda17855174faec1cd63e0b798fd1cdd8` |
| Superseded 2026-10-11 carrier | `3c5b3aaa32f9e638c2e641ff276e1791c61bcb14d61a78b524da60695a3b57d4` |

| Check | Observed result |
| --- | --- |
| Two emissions, same payload/keys | Both exit 0; 4.940s and 4.753s; complete bytes identical |
| Unchanged public wrapper with the pinned compilers/backend | Exit 0; all 2,580 hashes and scope/inventory pass; `MAP_DIGEST_BINDING=PASS`; empty stderr |
| Superseded carrier presented with the current manifest | Normal wrapper exit 1; `MAP_DIGEST_BINDING=FAIL` |
| Historical K4/K5 `make signed-verify` | Exit 0; all 1,506 hashes pass; `SIGNED_PAYLOAD=PASS` |

Receipts are in `resign-20261028/`; its `EXPORT_FILES.tsv` records raw/export
hashes, and only operational paths were normalized. The tables above and
`controls/`, `independent/`, `full-wrapper.*`, `public-download.*`, `sign.*`,
`repeat.*`, `SIGNING_FROZEN.sha256` and `PUBLIC_DOWNLOAD.md` describe the
superseded carrier and are retained unchanged as historical observations; the
corruption controls were not regenerated for the current carrier. The signing
identity, public keys and fingerprints are unchanged. **FORMAL_PROOF_SUBMITTED**
and direct-native **BLOCKED** remain unchanged.
