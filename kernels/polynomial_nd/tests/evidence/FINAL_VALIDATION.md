# Final-source verification receipt

Author: STARGA Inc.

The final kernel SHA-256 is
`7eed71f7cb06715744471edf80da5b6b1f3cdadb2ba345e3605814d2951fa3e2`.
It was copied verbatim to three fresh build inputs; all three copies match that
digest in `final-identities.sha256`. The pinned compiler remains
`a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa`,
using LLVM 20 through the environment in `COMMANDS.md`.

| Harness | Build exit | Run exit | Actual checker calls | Outcomes |
| --- | --- | --- | --- | --- |
| `main.mind` | 0 | 0 | 321 | 25 accepts, 296 rejects |
| `resource.mind` | 0 | 0 | 2 | 1 accept, 1 budget refusal |
| `cache.mind` | 0 | 0 | 3 | 2 accepts, 1 false-equality refusal |
| Total | | | 326 | 28 accepts, 298 rejects |

Every build/run stderr stream is empty. Native ELF inspection, source/compiler/
binary hashes, raw stdout, exit values and resource receipts are retained with
prefix `final-`. The exact final outputs are identical to the preceding outputs
under `cmp`; the source delta is comments only. The byte-identical executable
hashes before and after the repair are:

| Executable | SHA-256 |
| --- | --- |
| Main suite | `33ede8b8c6480d6587294f3c2b3382d41e133e6bb42eccd326b90b0f2f8c5f81` |
| Resource probe | `486cb056754b6a1b962faf33c0ed3ace34279d18a0c47478e6b72b377e0c6469` |
| Cache probe | `eb4fe19d7a3e8f61a71875fa0cd5508c707090de64c3dc54e858418f72475736` |

The earlier raw results remain intact and are explicitly tied to their earlier
source digest. The independently generated 54 certificate files remain
unchanged; all 54 digest checks passed in `certificate-hash-check.stdout`.

Review status: `PASS_WITH_NOTES`, with the workspace-comment finding resolved.
Theorem status remains `FORMAL_PROOF_SUBMITTED`; `FORMAL_ACCEPTANCE=BLOCKED`.
Independent owner acceptance, source mutation runs, and LLVM 23 comparison
receipts belong to the integrator's wider validation scope.
