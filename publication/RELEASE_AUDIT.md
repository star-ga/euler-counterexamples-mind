# Public review release audit

Author: STARGA Inc.
Date: 2026-10-11

Scope: the separate public repository `star-ga/euler-counterexamples-mind`. The owner
authorized publication of this Euler artifact. Other research repositories,
their histories and their access information are excluded. Existing rights
are reserved under the root LICENSE.md; no new open-source grant is selected.

## Observed execution

- The original pinned compiler accepted the structured Euler certificate.
  The inference kernel checks arithmetic, rule premises, substitution,
  assumption scope and discharge. The earlier template recognizer is retained
  separately as regression evidence.
- The main kernel suite passed eight initial positive fixtures, 1,585 expected
  rejections and a restored Euler acceptance. A separately authored MIND
  harness passed 33 cases; the original benchmark passed 1,240 negative checks.
- A compiler freshly built from the documented public source and locked
  dependencies built and ran all four programs. Each ELF matched the
  corresponding historical artifact byte-for-byte. The compiler itself had a
  different digest and is documented as a separate qualified profile.
- Eight actual checker-source mutants built successfully. Each preserved its
  valid positive control and wrongly accepted its designated invalid proof,
  which the original checker rejected normally. No crash or build failure was
  counted as successful fault detection. Failed orchestration attempts remain
  archived and explicitly excluded from successful outcomes.
- All four public-source-built ELFs produced identical stdout, stderr and exit
  codes on a second Linux x86-64 host. This was execution replay of transferred
  binaries, not a source rebuild or a different compiler implementation.
- The repository-root Make targets `verify test review regression` passed
  with the public-source compiler. Mathematical and test decisions execute in
  MIND; Make only orchestrates the build and run.

Exact commands, hashes, observations and limitations are linked from
REPRODUCE.md and toolchain/public-source/README.md at the repository root.
There is no arbitrary-platform bit-identity claim.

## Integrity, provenance and disclosure

All 88 entries in publication/SOURCE_SHA256SUMS retain their reviewed original
bytes. This includes MIND source, certificate inputs, mutation diffs and build
manifests. Current prose uses MIND; historical source comments and frozen
records retain their original spelling. Operational paths and host aliases in
public text receipts were sanitized. Initial redactions are recorded in
EXPORT_TRANSFORMS.tsv; later editorial changes are bound by the public Git
commit and regenerated release manifest.

Original work is attributed to STARGA Inc. The known counterexample is
attributed to Roger Frye, with the relevant historical mathematical sources
identified in PROVENANCE.md. External papers, screenshots, private repository
history, compiler executables and system libraries are not redistributed.

A separate AI agent reviewed the export, protected hashes, rule/implementation
evidence, mutation outcomes, public toolchain profile and cross-host receipts.
Its review found no substantive publication blocker. This is a source and
release review, not external human validation of kernel soundness.

A local Repomix security scan reported no suspicious files among 1,172 eligible
files and exited 0. It ran with a 1 GiB cgroup memory cap, zero swap, one CPU
quota and nice19; reported peak memory was 203.9 MiB. No packed source was
uploaded. The tracked-file inventory was also reviewed for private paths,
credential patterns, operational machine identifiers, binaries and symlinks.
These checks reduce disclosure risk; they are not a guarantee that any scanner
detects every possible secret. Build caches and local ELFs are gitignored.

Nested SHA256SUMS files describe the public bytes relative to their containing
directories. The repository-root SHA256SUMS covers all tracked release files
except itself. Historical differently named execution/source manifests remain
historical evidence, not substitutes for the public release manifest.

## Verification boundary

Status remains FORMAL_PROOF_SUBMITTED. The candidate kernel accepted the
certificate. Kernel soundness has not received the acceptance required by
PROOF_POLICY.md; no NATIVE_VERIFIED decision is made by this publication.
The compiler and runtime remain in the trusted computing base.

The historical unsigned kernel MIC artifact was a lossy IR summary and is not
offered as semantic attestation of this checker. The release's separate signed
carrier instead binds a manifest of the actual source, certificates and
evidence. Signing does not close the kernel-soundness or compiler-correctness
obligations. This work claims neither a new counterexample nor RH progress.

## K5 and signed-package extension

The same kernel source checks the K5 certificate without any new inference
rule. The added exact-goal wrapper and MIND test suite passed all 42 static
paired tests and 2,090 parser corruptions. Two separately prelisted real source
mutants exposed removal of fifth-power and positivity statement binding.
The original compiler and all 88 protected K4 source artifacts remain unchanged.
See the K5 benchmark's RESULTS.md and publication/k5-cross-host/RESULTS.md.

The public-source compiler also built and ran both K5 programs and both MIND
MAP-binding programs. K5 outputs match the historical profile, but ELF bytes
differ; publication/k5-public-profile/RESULTS.md records that distinction.

The hybrid signature uses both ML-DSA-87 and SLH-DSA-SHAKE-256s. Both public
keys, fingerprints, the exact signed manifest, embedded signatures and
commands are in signing/. A separate public compiler profile supplies the
crypto verifier. Nine prelisted diagnostic controls exercised wrong key pins,
each corrupted or removed signature, and modified signed attributes; every
negative control was rejected with normal exit 1. Final-artifact checks and
public-download verification are recorded under signing/execution/.

The signer is a dedicated project key created for this release, with private
seeds retained outside the repository. Signatures establish provenance under
the selected key identity and do not approve mathematical soundness.

The extension received separate automated implementation reviews in K5_REVIEW.md
and SIGNING_REVIEW.md. Neither authorizes formal acceptance. A second local
Repomix scan of the expanded tree exited 0 and found no suspicious files among
1,487 eligible files; peak cgroup memory was 209.6 MiB, zero swap, one CPU.
The first scan invocation failed to resolve its executable and was not counted;
the corrected absolute-path invocation scanned the intended repository.
Final key-material and manifest-coverage checks are recorded with the release.
