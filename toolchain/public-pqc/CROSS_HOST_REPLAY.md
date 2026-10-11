# Independent-machine cryptographic replay

Author: STARGA Inc.

The signed diagnostic's pinned-key verification was repeated on a separate physical machine running Linux under WSL with glibc2.39. The same already-built compiler ELF, signed artifact and two public-key files were transferred; no private signing key, credential, compiler source, shared workspace or GPU workload was transferred or modified. This is an independent-machine replay of one fixed cryptographic verification case, not an independently implemented verifier or cross-machine compiler rebuild.

| Input | SHA-256 |
|---|---|
| Compiler | 1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e |
| Signed diagnostic | 0f941b637d620ef4d9aac6ea38c8f362df492a43c91b53536fb28a48436854f4 |
| ML-DSA-87 public-key file | 22076215501568cc11703013214eecb8f299489f78c80025dc059a0dfa366811 |
| SLH-DSA-SHAKE-256s public-key file | 1d6bd469c3da9b2f6297148eb3ea2685bd2a04531cf5973a334a913f5441c479 |

The second host used one CPU, nice19,1GiB address-space limit,25CPU seconds and30wall seconds, with a clean environment containing only PATH and the C locale. Public keys were passed as explicit pins. The verifier exited0, reported the expected two-leg scheme with valid trace hash/SSA and provenance_authenticated=true, and wrote empty stderr.

| Stream | Host A versus Host B | SHA-256 |
|---|---|---|
| stdout | Byte-identical,5812bytes | b5130e4c7f22794b92819c866a77d9907f8e58086d01f65b3ded710b47d1ba80 |
| stderr | Byte-identical,0bytes | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 |
| exit-code receipt | Byte-identical,`0` plus LF | 9a271f2a916b0b6ee6cecb2426f0b3206ef074578be55d9bc94f6f3fe3ab86aa |

Host OOM-kill counters were0 before and after the replay. These are aggregate host counters, not an isolated per-process memory measurement. No peak-RSS claim is made. Live preflight had sufficient available memory and disk for this small verification job; it was not an exclusive resource reservation.

Two earlier transport attempts failed before returning a verifier result: an input-stream wrapper timed out, and a multiline argument wrapper failed with a shell quoting error. Neither is counted as a verifier failure or successful replay. The completed attempt transferred an explicit temporary runner and invoked it by filename. Original transport diagnostics are retained privately; only the successful verifier's unmodified input hashes/stdout/stderr/exit and neutral host metadata appear here. No host names, addresses, access routes or local scratch directory names are included.

The first-host baseline receipts are `receipts/baseline.*`; the second-host receipts are `receipts/host-b/verify.*`. Both used relative `signed.mic3` in the actual invocation, so the raw JSON artifact path already matches without text rewriting. The key-pinning JSON limitation in SIGNATURE_CONTROLS.md still applies: process exit0 is mandatory.
