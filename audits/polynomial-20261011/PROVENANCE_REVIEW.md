# Independent polynomial-release provenance review

Author: STARGA Inc.

Date: 2026-10-11. Method: independent model-assisted source review. This is not human review, cryptographic-library certification, mathematical approval, or an authorization to change formal status.

Base commit: `cacb9492a0c356dd094d08972910fda9232b4472`. Reviewed worktree: `<review checkout>`. Changes under `signing/polynomial/` were uncommitted during review. All references to old/new wrapper revisions below are disambiguated by SHA-256, not merely by the base commit.

Current review state: pre-signing source review completed and frozen. Both substantive findings below were remediated in the wrapper source before this freeze. Final wrapper SHA-256: `9754e8945992555de32f0a4ee7927f4c8f1a427cc7c8a05212fe5f27498b7107`. Final signed manifest/carrier and full execution controls have not yet been supplied. `FORMAL_PROOF_SUBMITTED` remains unchanged; direct-native remains `BLOCKED`. No private-key access, signing operations, product-source edits, or builds were performed by this reviewer. The only authorized repository additions by this reviewer are this report's public export and its raw/export hash receipt.

## Finding P1: bootstrap trust gap in initial wrapper

Severity: high for a trusted-wrapper/untrusted-payload verification contract. This concerns provenance verification, not `POLY_ID` soundness.

Initial `signing/polynomial/verify.sh` SHA-256: `ba215a812cec23327b694c6652a9b4cc8e8cbb70f9e5a5ea6da776d58947f586`.

At line 22, the initial wrapper ran `make -C "$repo" binding-check`, executing the repository Makefile and compiling repository bridge source before any authentication of those bytes. At line 28 it then trusted the generated bridge's decision about whether the signed carrier authenticated the manifest digest. Listing those same sources in a later signed manifest does not solve this dependency cycle.

Concrete source attack: retain a genuine project-signed carrier and public keys; replace the bridge implementation with a program returning success for any digest; replace the manifest and payload with attacker-selected bytes whose hashes agree. The cryptographic verifier still accepts the genuine carrier, the forged bridge discards the crucial signed-digest-to-manifest relationship, and file-hash verification accepts the replacement manifest. The initial wrapper then reaches its success marker. Modifying the executed Makefile is an even earlier arbitrary-code path. This argument assumes only the entry wrapper/toolchain are trusted and the checkout contents are under examination; if the entire checkout is already trusted, that narrower premise must be stated explicitly.

**Source remediation verified.** Revised wrapper SHA-256 `575d18ded5fa5b3f027fa07c5a58fbfce6c58946971c88f6a7dd7083b73fb93d`, lines 22-43, does not execute the repository Makefile. It stages exactly three files into private scratch and checks hardcoded hashes before compiling:

| Staged file | SHA-256 |
| --- | --- |
| `Mind.toml` | `4c08d6ac178f5aa0514e3494226b950244553b00a143772dd68e17277ac8f600` |
| `src/bridge.mind` | `a6fa375827cca00fbfe0d79e06c2a0c09b37efad4e9fe59c5aca0450cbcbfe0a` |
| `src/main.mind` | `fcc41d9b61b6b2db8a6b3fa8cb17b8829c9cef7b13b35639edeba9cddfe80325` |

It also checks the three explicit LLVM20 tool hashes, which I independently recomputed, and invokes compilation under a clean environment with explicit backend paths. The script and its embedded pins remain a trusted bootstrap that must be obtained through a trusted channel. Bash syntax checking passed. This source fix has not yet been exercised by this reviewer against a tampered-source fixture.

## Finding P2: valid historical signature can be mislabelled as polynomial scope

Status: present at wrapper revision `575d18ded5fa5b3f027fa07c5a58fbfce6c58946971c88f6a7dd7083b73fb93d`; source remediation verified in final revision `9754e8945992555de32f0a4ee7927f4c8f1a427cc7c8a05212fe5f27498b7107`.

The exact bridge checks generic `org.starga.attestation_scope = package-provenance` (`signing/map-binding/src/bridge.mind:119`). The wrapper's lines 17-18 select files from the polynomial directory, but their directory names are not authenticated claims of polynomial coverage. After accepting their manifest, line 51 unconditionally prints `POLYNOMIAL_SIGNED_PAYLOAD=PASS`.

Concrete replay construction: place the existing historical `signing/package.mic3` and historical `signing/PAYLOAD_SHA256SUMS` at the new polynomial package/manifest paths, without changing their bytes. Both use the same project keys and exact carrier profile. The historical 1,506-row manifest contains no `kernels/polynomial_nd/` or `signing/polynomial/` entries, confirmed by direct inspection. Since historical payload bytes are explicitly to remain unchanged, their hash check still succeeds. The wrapper therefore has no source-level check that the signature covers any polynomial artifact at all.

This does not forge either cryptographic signature. It is a release-scope/replay confusion: authentic historical provenance is being reported as authentic polynomial-package coverage. Before release, require authenticated manifest entries identifying the polynomial kernel, current audit/evidence scope, verifier/control sources, and expected release inventory, or bind the exact expected new manifest digest through an independent trust channel. Final manifest-set comparison should separately establish completeness of the intended release set.

**Source remediation verified.** Final wrapper lines 50-75 require ten named polynomial-release manifest entries, including the polynomial kernel, both main certificates, test cases, current audit/source-review/corpus evidence, wrapper, tamper source, and `PAYLOAD_FILES.txt`. They reject malformed digest rows, nonrelative paths, dot/parent components, duplicate paths, doubled slashes, and trailing slashes. After cryptographic and digest-binding success, the wrapper checks payload hashes and then byte-compares the manifest's ordered path list with the now-authenticated `PAYLOAD_FILES.txt`. A historical K4/K5 manifest cannot meet the mandatory polynomial entries.

The intermediate scope fix, SHA-256 `a7375a50a701dd5891e3a8fd78c69a092042228e378557f2703c4e1c58931ac7`, still allowed doubled/trailing slashes despite claiming canonical paths. I reported this representation edge separately; final line 68 rejects both. This was a path-canonicality correction, not a signature forgery or a `POLY_ID` defect.

I executed the final wrapper's exact AWK parsing block in isolation with seven inputs. A syntactically valid manifest containing all required paths exited 0. The authentic historical 1,506-row manifest, duplicate path, parent traversal, absolute path, doubled slash, and trailing slash fixtures each exited 1. Every case produced empty stderr. These are manifest-syntax checks only, not complete signature-verification runs or theorem checks. Final `bash -n` also exited 0.

The authenticated inventory comparison establishes internal agreement between the signed manifest and its signed path list. It does not independently prove that the signer selected every intended release file; the final release-set comparison remains a separate reviewer obligation. A future explicitly signed polynomial release containing the required scope may also verify; this script is not an anti-rollback monotonic-release protocol.

## Verified source properties and boundaries

Public project identity is a pair of independently selected fingerprints. I recomputed the decoded public-key lengths and SHA-256 values:

| Public key | Decoded length | SHA-256 |
| --- | --- | --- |
| ML-DSA-87 | 2,592 bytes | `0c7f47a456f77dbacbbdd4a5a03328b20543859461dc9c00f49289467a594eb0` |
| SLH-DSA-SHAKE-256s | 64 bytes | `ac85e7ecbd748a1ab57e67e44ca9b60e490ba7a7786e9ef4c707f790531c1e84` |

Both public hex files are canonical lowercase hex plus a final LF. The wrapper hashes decoded bytes and supplies both full keys explicitly. It unsets `MIND_EVIDENCE_VERIFY_PUBKEYS`, preventing inherited extra allowlist entries from widening trust. Public key arguments are not secret material. Project-key identity is distinct from a pre-established organization-wide trust root; `signing/README.md:25-30` requires independent owner-channel confirmation.

The wrapper requires crypto verifier exit success, signed evidence, strict-FP metadata, and deterministic metadata before trusting the bridge result. It snapshots carrier, manifest, and public keys so the crypto verifier and bridge read the same carrier bytes. Payload files themselves remain in the checkout, so a frozen checkout/no-concurrent-writer contract is still required through payload hashing and subsequent use. Compiler binaries, backend libraries, loader, shell, hash utilities, and OS remain explicit bootstrap/TCB dependencies.

The strict bridge is deliberately not a cryptographic verifier. `bridge.mind:83-133` fixes the entire 35-byte body, exact 13-field count/order, field tags/lengths, production hybrid scheme, lowercase expected digest plus LF, exact digest equality, and exact EOF. It checks the digest field at lines 120-122 and the hybrid scheme at line 126. `pb_nat` uses bounded minimal ULEB128, and `pb_take` bounds each read before advancing the cursor. The signature values themselves are checked only for lengths by this component; separate cryptographic success on the same bytes is essential.

I also read the locally retained public cryptographic verifier source corresponding to the documented public-PQC profile. Source identities inspected were `src/bin/mindc.rs` SHA-256 `8f3a4f35da2cd28b077c3484cff030ab01e8f3f8d26d9ab5fd4774205b0cdd93` and `src/ir/compact/v3/evidence.rs` SHA-256 `a302a694efb2f054b1e2684e8c59b81ee61302fe10675d2294d6b9fa91e54570`. This is source-path inspection, not a fresh source-to-binary proof. The retained verifier executable independently hashes to the wrapper's default `1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e`.

Relevant dependency-source behavior:

- `evidence.rs:1179-1180,1240-1289` requires both ML-DSA-87 and SLH-DSA verification for the production hybrid. A failed leg returns non-valid status before the final `Valid` result.
- `evidence.rs:1462-1493` includes every application MAP field in the signature preimage by excluding only `signature.*` and the separately prepended trace hash. Thus the package-manifest digest is cryptographically bound; the nearby narrower historical comments do not override the actual filter at line 1476.
- `mindc.rs:2559-2600` requires every embedded verified public key to be in the explicit allowlist; nonempty key collection is checked. `mindc.rs:1966-1991` also explains why clearing the environment allowlist matters.
- `mindc.rs:2459-2460` computes its JSON `provenance_authenticated` field before the later allowlist rejection. Therefore process exit status is essential; a superficially positive JSON field alone is insufficient. The wrapper stops on nonzero exit.

## Tamper generator review

`signing/polynomial/tests/tamper.mind` SHA-256: `f21d6cad6bacebc07bc305a5c0e6fea8cf55a130e629a64ae7741a2be9d3b340`.

The generator accepts only the exact bridge profile with length 37,642 and the supplied expected digest (`tamper.mind:37-39`). It then writes three distinct copies: increment the first ML-DSA signature byte at offset 440; increment the first SLH-DSA byte at offset 7760; replace the first digest digit at offset 355 with a different valid hex digit (`tamper.mind:25-30,40-49`). Each signature byte is restored before the next output; the digest is changed from `0` to `1`, or any other valid first digit to `0`, guaranteeing inequality without introducing invalid hex.

I independently parsed the public historical carrier's field boundaries without dumping signature/key material. Its exact profile confirmed digest offset 355/length 64, ML-DSA signature offset 440/length 4,627, SLH-DSA signature offset 7760/length 29,792, final end offset 37,642. The strict profile fixes every preceding length and ordering, so these offsets do not depend on a substring search or on current signature contents.

Reads are bounded by caller-allocated `cap+1` bytes and require EOF, including a one-byte oversize probe. Partial writes are retried; write/read/allocation/setup failure yields generator exit 2. Generation alone never proves a signature invalid. The generator's structural bridge check does not authenticate input signatures; its driver must first verify the positive carrier cryptographically. The driver must then require each cryptographic negative to terminate normally with the documented refusal exit (1), distinguishing setup/I/O exit 2, timeout 124, and signals/crashes. The generator has no secret-key inputs and outputs only public carrier bytes.

## Manifest and final-artifact review still pending

The proposed cycle-free structure is appropriate in principle: a new polynomial payload manifest binds selected source/evidence/toolchain files; the new signed carrier binds that manifest digest; the new root checksum inventory includes completed carrier and execution reports. The signed manifest must exclude itself, its carrier, and the post-signing execution reports that would otherwise form cycles. Those excluded receipts remain supplementary unsigned observations unless authenticated separately. Root checksums provide file integrity relative to a trusted root manifest, not an extra cryptographic signature.

The historical `signing/package.mic3`, historical `signing/PAYLOAD_SHA256SUMS`, and all 1,506 historical payload bytes must remain unchanged. At pre-signing review time, an independent `sha256sum -c --quiet signing/PAYLOAD_SHA256SUMS` on the reviewed worktree exited 0 with empty output, covering all 1,506 historical payload entries. Final invariance of that historical manifest/carrier and payload, a complete new manifest-set comparison, final signed-carrier verification, both one-leg tamper refusals, altered-digest refusal, wrong-manifest refusal, historical-scope replay refusal, altered-bootstrap-source refusal, and explicit refusal/error-exit classification remain to be checked when the completed artifact is supplied.

No confirmed unresolved blocker was found in the final wrapper/tamper source under its documented trusted-bootstrap and frozen-checkout assumptions. This is a pre-signing source-review result; it does not assert completed signature execution controls, cryptographic primitive correctness, source-to-binary equivalence, or mathematical approval. Final-artifact observations must be recorded separately so this signed pre-signing report does not acquire a circular dependency on its own eventual signature.
