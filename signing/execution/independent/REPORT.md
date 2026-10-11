# Final package independent verification

Author: STARGA Inc.
Date: 2026-10-11
Result: PASS for package cryptographic authentication, manifest binding and the scoped replay checks below.

The final signed package was independently verified on two physical machines. Both signatures were checked against the two full explicit public-key pins, with signed, strict-FP and deterministic requirements enabled. The MIND MAP binding checker separately accepted the SHA-256 digest freshly computed from the exact manifest bytes on each host. All four verifier calls exited0 normally and wrote empty stderr. Their outputs and exit-code receipts were byte-identical across hosts.

This authenticates and binds the supplied package bytes. It does not approve the mathematical kernel's soundness, establish native/source equivalence, promote proof status, or make an RH claim. The package still requires its separately documented mathematical review.

## Frozen identities

| Input | SHA-256 |
|---|---|
| Final package.mic3 | aade52f3d0c3ad874ff7c25113f423f487c0579e864cf71ddf1833618ba86918 |
| Exact PAYLOAD_SHA256SUMS bytes | d3471291b15b9e3f6d43860d4525729098c628472f7812611c2ae522a1d83965 |
| Cryptographic verifier ELF | 1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e |
| MIND MAP binding checker ELF | 9f4241c8eaf032cce25e6892cf0f599a87d7b3848e705c398d4554488db2dc14 |
| ML-DSA-87 public-key file | 22076215501568cc11703013214eecb8f299489f78c80025dc059a0dfa366811 |
| SLH-DSA-SHAKE-256s public-key file | 1d6bd469c3da9b2f6297148eb3ea2685bd2a04531cf5973a334a913f5441c479 |

The included input hash receipts identify the same frozen bytes on both hosts. No private keys were read or transferred. The second host reused the exact previously qualified cryptographic verifier after checking its hash; only public package/manifest/key files, the MIND checker and bounded execution instrumentation were newly transferred. No signing or compiler rebuild occurred in this lane.

## Observed results

| Check | Host A | Host B | stdout SHA-256 |
|---|---|---|---|
| Both pinned signatures, strict FP, deterministic | exit0 | exit0 | 2243b01132a0f705af24c7b75c126c002029ee5b287340f9726a5bb6bac588aa |
| MIND manifest-digest binding | exit0, MAP_DIGEST_BINDING=PASS | exit0, MAP_DIGEST_BINDING=PASS | b8a85d0af6dc67cf372e5e0828bc409b31aa064018a9761309d0036c259d4e5f |

Cryptographic stdout is5813bytes. MIND binding stdout is24bytes. Every stderr is empty, SHA-256 `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`. Every exit receipt is the two bytes `0` plus LF, SHA-256 `9a271f2a916b0b6ee6cecb2426f0b3206ef074578be55d9bc94f6f3fe3ab86aa`. COMPARISON.json records the byte comparisons and both hashes independently.

Cryptographic JSON reports the expected `pqc-hybrid-ml-dsa-87-slh-dsa-256s` scheme, valid trace hash, valid SSA and provenance_authenticated=true. Successful process exit0 is also required: the separately documented wrong-pin reporting caveat makes that JSON boolean insufficient on its own.

Host A additionally ran a strict full check of every listed payload-file hash from the public repository root. It exited0 with empty stderr; complete relative-path stdout is retained in host-a/payload-check.stdout. This additional full-file check was not repeated on Host B, which received only the public verification inputs. Both hosts independently hashed the exact manifest before passing its lowercase digest plus LF on fd3 to the MIND checker.

## Commands and limits

The cryptographic invocation was equivalent to:

```sh
env -i PATH=/usr/bin:/bin LANG=C LC_ALL=C \
  <PQC_MINDC> verify --json --require-signed --require-strict-fp \
  --require-deterministic --signer-pubkey <FULL_ML87_PUBLIC_KEY> \
  --signer-pubkey <FULL_SLH_PUBLIC_KEY> package.mic3
```

The empty environment ensures MIND_EVIDENCE_VERIFY_PUBKEYS is absent; inherited extra trust anchors cannot widen the explicit pair. Keys were read only from the supplied public .pub.hex files. Each binding call used the same frozen package on stdin and the independently computed manifest digest on fd3:

```sh
<MAP_BINDING_CHECK> < package.mic3 3< computed-manifest-digest.txt
```

Each verifier call ran on one CPU with nice19,1GiB address-space limit,25CPU seconds and30wall seconds. Host A used Linux/glibc2.43; Host B used Linux under WSL/glibc2.39 on a separate physical machine. Host B's Windows preflight reported3,471,776KiB free physical memory and passed the1GiB headroom guard. Aggregate host OOM-kill counters were unchanged: Host A1→1, Host B0→0. These counters are host-wide observations, not isolated process-memory or peak-RSS measurements. No GPU or shared-workspace changes were made.

## Receipt handling

The prelist and all input/execution-script hashes were frozen before the verifier calls and rechecked afterwards. The frozen mathematical/public payload was not modified. All files here are supplementary execution observations intended for the excluded signing/execution directory; they are not additional claims inside the already signed payload manifest.

Host A and Host B are neutral labels. Actual verifier calls used relative `package.mic3`, so stdout/stderr/exit files are unchanged; no text replacement was needed to compare them. Published command paths use explicit placeholders and omit machine names, addresses, access routes and scratch paths. The private remote-directory receipt and transport diagnostics are excluded. This evidence concerns the recorded fixed inputs on these two hosts; it is not a universal cross-platform claim or verification by an independently implemented cryptographic library.
