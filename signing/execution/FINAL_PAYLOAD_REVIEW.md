# Final signed payload review

Author: STARGA Inc.
Date: 2026-10-11

**Verdict: PASS for the frozen payload, protected-source integrity and local signed-package verification described below.** This is an automated-agent release review. It does not authorize mathematical proof-status promotion or establish an external trust root for the project's public keys.

## Frozen bytes and manifest coverage

| Artifact | Bytes / entries | SHA-256 |
| --- | --- | --- |
| `signing/PAYLOAD_SHA256SUMS` | 199,433 bytes; 1,506 entries | `d3471291b15b9e3f6d43860d4525729098c628472f7812611c2ae522a1d83965` |
| `signing/package.mic3` | 37,642 bytes | `aade52f3d0c3ad874ff7c25113f423f487c0579e864cf71ddf1833618ba86918` |
| `publication/SOURCE_SHA256SUMS` | 88 protected entries | `8f240f949d9e45b3efe4c8ef8624900dee02af88811db10d5b0195529aef3926` |

An independently constructed inventory from Git's tracked index contained 1,519 paths at review time. Removing exactly the documented exclusions produced 1,506 paths, equal to the manifest path set. The exclusions are the payload manifest itself, `signing/package.mic3`, everything below `signing/execution/`, and files whose basename is `SHA256SUMS`. The comparison found no missing or extra paths, duplicate entries, malformed digest records, absolute paths, parent-directory traversal or control characters. Later staging of the signature and excluded execution receipts does not add covered payload paths.

Every one of the 1,506 payload digests verified. All 88 protected digests also verified; the protected manifest itself is unchanged from the repository's previous commit. The compiler pin, generic kernel source, authorship policy and proof policy are likewise unchanged from that commit. A second payload/protected-source verification after the cryptographic checks also passed, and the working-tree signature and manifest still byte-matched the frozen verification copies.

The tracked-file mode inventory contains regular files only. Its sole executable source file is the existing reviewed `toolchain/public-source/cross-host-replay/run.sh`, which orchestrates bounded native runs, hashes and output comparisons. No Python, Rust, Lean, JavaScript, TypeScript, C, C++ or Go implementation source is tracked. Cargo lockfiles and compiler-build receipts describe explicit external toolchain dependencies; they do not introduce a mathematical runtime or authority replacement. Make and shell remain orchestration.

## Independently executed local verification

The reviewer used the actual pinned executable hashes, with an empty inherited environment and only `PATH`, `LANG` and `LC_ALL` supplied. Each native call ran with one CPU, nice 19, a 256 MiB address-space limit, a ten-second CPU limit and a fifteen-second wall timeout. No build, key generation or signing was performed by the reviewer.

| Executable | SHA-256 |
| --- | --- |
| Official public-profile PQC verifier | `1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e` |
| MIND MAP binding checker | `9f4241c8eaf032cce25e6892cf0f599a87d7b3848e705c398d4554488db2dc14` |

The cryptographic invocation was `mindc verify` on a frozen copy of the final artifact with `--json --require-signed --require-strict-fp --require-deterministic` and two `--signer-pubkey` arguments containing the complete published ML-DSA-87 and SLH-DSA-SHAKE-256s public keys. It exited normally with zero and empty stderr. Its JSON reported the hybrid signature profile, `provenance_authenticated=true`, a valid trace hash, strict FP metadata and deterministic metadata. Success required the process exit value, not merely JSON fields.

The same frozen artifact bytes were then supplied on stdin to the MIND binding checker. File descriptor 3 contained SHA-256 of the frozen manifest's exact bytes, as 64 lowercase hexadecimal characters and one LF. The checker exited normally with zero, empty stderr and exactly `MAP_DIGEST_BINDING=PASS` plus LF. Together with cryptographic verification and the successful file-hash checks, this binds the listed release bytes to the selected published signing-key pair.

Observed public-key fingerprints, computed from decoded bytes rather than hexadecimal text:

- ML-DSA-87: `0c7f47a456f77dbacbbdd4a5a03328b20543859461dc9c00f49289467a594eb0`.
- SLH-DSA-SHAKE-256s: `ac85e7ecbd748a1ab57e67e44ca9b60e490ba7a7786e9ef4c707f790531c1e84`.

These equal the published fingerprints. Identifying them as an owner-approved organizational identity still requires the independently trusted owner channel described in `signing/README.md`; possession of matching keys and artifacts alone does not establish that external trust.

The local OOM-kill counter remained 1 before and after both runs. The signing session's separate repeat receipt records two successful emissions and byte-identical final artifacts. This reviewer checked that receipt and the final artifact digest; the reviewer did not independently repeat signing or access the private seeds.

## Disclosure and status checks

The staged path inventory contained no private-key, seed, credential, `.env`, `.key` or `.pem` files. Bounded scans of tracked content for common private-key envelopes, provider-token formats, literal private-key environment assignments and conventional private credential paths returned no matches. These checks did not inspect external credential files or private seeds. They are scoped disclosure checks, not a proof that every possible secret encoding is detectable; the separately documented full-tree scanner supplies additional evidence.

`PROOF_POLICY.md` remains SHA-256 `02c95b28529c02c4f011992aee483a5aacef41039e27b11a033859fda0820b0c`. It explicitly retains `FORMAL_PROOF_SUBMITTED`, requires designated soundness/TCB acceptance before `NATIVE_VERIFIED`, and states that no such approved acceptance decision is present. The main README, K5 documentation and signing documentation maintain that boundary. No RH claim or status change is introduced.

## Receipt identities and limits

| Local raw receipt | SHA-256 |
| --- | --- |
| Complete payload hash-check stdout | `4b63eb5f6aabee213c691a425bf86fc70a661c3898dfb6ebb70adb701a3cad16` |
| Protected-source hash-check stdout | `8f322d5a39298210a872c8a111cd1b4bdf028b4d5543c9c4848bbf3d7880bbac` |
| Cryptographic verifier stdout | `b36218ee39bdfe4e44c22872d9f3ebc5fbbf2cd00756bcee53ed5ab9b5f46119` |
| MIND binding stdout | `b8a85d0af6dc67cf372e5e0828bc409b31aa064018a9761309d0036c259d4e5f` |

The raw verifier JSON includes its local artifact path; sanitizing that operational path would change the raw receipt hash. The signed artifact and payload identities above are unaffected. This report itself is an excluded post-signing execution observation and is not a signed payload claim. The repository-root release checksum manifest and final Git commit are assembled separately after this review.

This gate establishes the observed local provenance-verification result and byte coverage. It does not assert that the constant-return carrier implements the mathematical kernel, prove source-to-executable equivalence, validate the kernel's soundness, establish novelty of either known counterexample, or substitute for the recorded proof-policy acceptance requirements.
