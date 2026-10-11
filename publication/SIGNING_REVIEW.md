# Independent technical review of package provenance

Author: STARGA Inc.

Date: 2026-10-11. Verdict: **PASS_WITH_NOTES** for the source, commands and
retained diagnostic evidence identified below. No blocking implementation
defect was found within this scope.

This was an automated, AI-assisted review by a separate review lane that did
not author the MAP bridge. It is not external human approval, an independent
cryptographic implementation, or approval of mathematical kernel soundness.
No source, theorem status, compiler pin or signing key was changed. No private
key was requested or inspected. The review read source and existing receipts,
checked hashes and searched for publication leaks; it did not rerun the native
or cryptographic campaigns.

## Exact reviewed inputs

Paths are relative to the publication root. SHA-256:

| File | SHA-256 |
| --- | --- |
| `signing/map-binding/src/bridge.mind` | `a6fa375827cca00fbfe0d79e06c2a0c09b37efad4e9fe59c5aca0450cbcbfe0a` |
| `signing/map-binding/src/main.mind` | `fcc41d9b61b6b2db8a6b3fa8cb17b8829c9cef7b13b35639edeba9cddfe80325` |
| `signing/map-binding/tests/suite.mind` | `18ad4e975d592f421f9125807cdbca8bdfc98b772ae0ebd63bedfa83633a7635` |
| `signing/map-binding/README.md` | `0bc5ee9c43b3c28486882d2da014d0a5a6b3d1f0be893876eca13e334a467909` |
| `signing/README.md` | `a3f15b2f94a1dab77f9c2772b3d8d76b284b14e397a33d585a44d3eecd42aa73` |
| `Makefile` | `44e91bcc82dbb0cc959118800e623475265bfab68e6dd015ebb3f084000def17` |
| `signing/map-binding/reference/carrier-body.mic3` | `f59773d526008bf435f985b1c4f66c28817b709e0f6c509f0f73d0189c45e13f` |

All eight entries in `signing/map-binding/tests/FINAL_CONTENT.sha256` verified
against the inspected files. The carrier body is exactly 35 bytes.

## Parser and digest-binding review

`bridge.mind:37-41,92-100` fixes the complete carrier body and then reads the
MAP sentinel at offset 35. There is no scanning for an apparent marker inside
untrusted data and no caller-selected MAP offset. Exactly 13 entries must
follow. `bridge.mind:43-56,96-109` requires each field name, order and type.
This also rejects duplicate, unknown, omitted or reordered fields. Future
carriers, additional attributes, alternate schemes, parents and unsupported
types are refused rather than interpreted permissively.

`bridge.mind:60-81` bounds each ULEB to three bytes and a value at most 131072.
A multi-byte encoding with terminal zero is rejected, enforcing minimal
unsigned encoding. The cursor is checked before each read; `pb_take` checks
remaining length using subtraction before advancing. ULEB intermediate values
and scales remain far below signed 64-bit overflow. All callers constrain
subsequent string/byte comparisons to validated spans.

`bridge.mind:83-94,114-132` requires the exact metadata values, schema encoding,
trace hash, scope, algorithm label and signature/public-key field lengths.
The expected digest must be exactly 64 lowercase hexadecimal bytes plus LF.
Its byte-for-byte equality to the 64-byte MAP String therefore also establishes
canonical hexadecimal syntax for that field. Exact EOF rejects both trailing
bytes and a second MAP section. Public-key and signature contents are deliberately
not authenticated by this function; only their wire shape is checked.

The public API explicitly assumes valid, caller-owned, nonoverlapping regions
(`bridge.mind:5-6`). It is not a memory-safety boundary for arbitrary forged
integer addresses. Under that precondition, input lengths and accesses are
bounded. `main.mind:13-34` establishes the precondition with three allocations
totalling 131155 requested bytes, including the extra byte used to detect
oversize input. Reads stop at EOF or the cap; I/O errors return exit 2, structural
refusal returns exit 1, and only acceptance plus successful output returns 0.
The checker has no recursion or input-proportional allocation. The Make recipe
adds one-CPU, memory, CPU-time and wall-time bounds.

## Cryptographic composition and failure behavior

`Makefile:53-65` checks the signature-verifier executable hash, creates a private
temporary copy of the carrier, manifest and public keys, and authenticates that
same copied carrier before passing it to the MIND binding CLI. It requires
signed, strict-FP and deterministic verification with both explicit public-key
pins. It removes `MIND_EVIDENCE_VERIFY_PUBKEYS`, preventing that environment
variable from silently adding trust anchors.

The shell uses `-eu -o pipefail`; failed compiler checks, copy operations,
cryptographic verification, digest computation, binding verification or payload
hash checks prevent the final `SIGNED_PAYLOAD=PASS` line. No JSON boolean is
used as a substitute for exit zero. This correctly addresses the observed
verifier behavior where wrong allowed keys produce exit 1 even though JSON
still says `provenance_authenticated=true`.

The manifest digest is computed from the exact copied manifest bytes. The MIND
checker binds that digest to the authenticated MAP claim, and `sha256sum -c`
then checks listed payload files. This is a signed-manifest composition; the
carrier is not the theorem checker. The source explicitly preserves that
distinction, as do `signing/README.md:96-105` and `PROOF_POLICY.md`.

## Evidence examined

The retained parser suite reports 4 expected accepts, 477 expected rejections
(46 named cases and 431 proper prefixes), zero unexpected results, exit 0 and
empty stderr. Source inspection confirms those counts and that expectations
are compared against actual `pqc_binding_check` returns. This is a bounded
prefix campaign, not every prefix of the 37642-byte synthetic carrier.

M01 removes only digest comparison. Its retained run accepts N01, N22 and N23
incorrectly while retaining all positive controls, and exits normally with 1.
M02 removes only EOF checking; it accepts N35 and N36 incorrectly, retains all
positives and exits normally with 1. Both stderr files are empty. These are
observed faulty acceptances, not crashes or compiler errors counted as success.
The synthetic signature bytes are intentionally not cryptographic certificates;
P03's structurally accepted altered signature makes that boundary explicit.

The separate `toolchain/public-pqc/SIGNATURE_CONTROLS.md` and nine-case raw
observations report the expected normal exits for the valid hybrid, two wrong
key pins, two changed signatures, changed manifest digest, changed scope and
two removed signatures. They identify a diagnostic signed fixture, not the
final release carrier. This review inspected that evidence; it did not produce
an independent cryptographic verification run or audit the underlying PQC
library implementations.

## Publication checks and remaining conditions

The inspected signing subtree, PQC profile and Makefile had no matches for
private-key headers, common credential formats, operational home/scratch paths
or private-network addresses in the targeted scan. Public verification keys
and synthetic signature fixtures are expected contents. No secret-bearing
environment or signing seed was accessed. This targeted inspection is not a
guarantee that arbitrary data elsewhere in the release contains no secrets.

The following limits remain explicit:

1. Public keys beside an artifact do not establish owner identity. Compare
   the decoded-key fingerprints through an independently trusted owner channel,
   as required by `signing/README.md:25-34`.
2. The carrier/manifest/key copies are frozen for the two verifier stages;
   payload files and build inputs remain in the checkout. The documented fresh,
   single-writer snapshot requirement remains necessary. This recipe is not
   an isolation mechanism against concurrent hostile writers or a hostile
   executable-loading environment.
3. Runtime hash checking verifies listed entries, not manifest exhaustiveness.
   The release process must separately confirm the documented tracked-file
   coverage and exclusions. Excluded execution reports are supplementary,
   unsigned observations; extra untracked files are outside the payload.
4. At the time of this source review, final `signing/package.mic3`,
   `signing/PAYLOAD_SHA256SUMS` and `signing/execution/` were not yet staged.
   Final-artifact verification, coverage and release-manifest checks therefore
   remain the release writer's separate gate. This verdict must not be cited
   as attesting those future bytes.
5. Cryptographic provenance, parsing acceptance and finite tests do not
   establish mathematical truth, source-to-executable equivalence or kernel
   soundness. Both candidate derivations remain `FORMAL_PROOF_SUBMITTED`.

No source correction is requested for this reviewed revision. The verdict is
limited to the exact hashes above and the stated operational and trust
preconditions; it does not approve `NATIVE_VERIFIED` or a formal soundness claim.
