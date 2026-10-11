# Observed native verification results

Author: STARGA Inc.
Date: 2026-10-11 UTC

## Identity and execution boundary

| Artifact | SHA-256 |
| --- | --- |
| Official pinned compiler | `a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa` |
| Kernel source | `ca181abc7430c32c324d10653fba3cca47cbf9a2d2cea30a5c97ec0ac4e13128` |
| Generic CLI source | `a4409fc9914c380ba0b45e5c9ed9f9b5242882cde70b9a38a6897aeb77bc9e59` |
| Exact Euler certificate | `e76cf839db6c67777d059a88da9a7a14bfd631ac4dadea4409d8028f5f8903a4` |
| Native CLI ELF | `133bee11b6f30f0be9b72ff8a6a05aef19d8d1bc3dcdd8183f1050262b8dd47d` |
| Final pre-execution suite manifest | `57c617b2eaba819a56adbfd36e4c59d3e7895918721f5b09ca9b54cf1f354f76` |

The source base is the original benchmark campaign commit ddd7a99a82d0cb1d891fd3bad012b3389033a4b4.
The compiler version is MIND 0.10.2/core-ir 1.0. Build used explicit LLVM/Clang
20.1.8 MLIR CPU lowering to ELF. It did not qualify the separate native emitter,
substitute the public-release binary, or change the repository pin. Backend,
linker and linked-library identities are recorded in evidence/dependencies.sha256.
The compiler's embedded CPU adapter sufficed; no separately configured MIND
shared runtime was required. Standard platform libraries remain trusted.

## Outcomes

| Check | Observed result |
| --- | --- |
| Exact Euler certificate through generic CLI | Exit 0, `KERNEL_CHECK=PASS` plus LF, empty application stderr |
| Main MIND suite | 8 static accepts, 1,585 rejects, and restored Euler accept; exit 0, empty stderr |
| Independently authored MIND suite | All 33 predeclared decisions matched; exit 0, empty stderr |
| Original unchanged benchmark | Exact arithmetic and template checks pass; 1,240 original negatives pass; exit 0 |
| Second-machine execution | Same CLI ELF and certificate accepted on HOST_B/glibc 2.34, exit 0; empty application stderr |
| Independent source/rule/arithmetic review | PASS WITH NOTES; exact statement binding checked separately |

The 1,585 rejections comprise 49 named invalid certificates, six API controls,
765 proper prefixes and 765 one-byte nondecimal substitutions of the Euler
certificate. The final restoration is an additional positive call. Independent
cases include `10^36-1`, overflow refusal, false equalities, nested binders,
wrong witnesses, stale assumptions, incorrect discharge and work exhaustion.
Tests are finite software evidence, not a proof of complete implementation
correctness. The same compiler/backend underlies both local review runs;
HOST_B is a separate machine executing the transferred ELF, not an independent
compiler implementation or rebuild.

## Actual source mutations

Every mutant was separately compiled from the exact baseline with one recorded
diff. Every build succeeded. Every positive control accepted normally. Every
baseline bad control refused normally with exit 1 and `KERNEL_CHECK=FAIL`;
every mutant bad control accepted normally with exit 0 and `KERNEL_CHECK=PASS`.
All application stderr was empty. An independent reviewer reexecuted these
pairs and compared raw stdout, stderr and exit values.

| Mutant | Fault exposed by bad-certificate acceptance |
| --- | --- |
| M01 | Skipped universal-instantiation result comparison admits a false theorem |
| M02 | Wrong witness replacement is accepted (invalid derivation; final formula happens to be true) |
| M03 | Forged ground equation `0=1` is accepted |
| M04 | Closed creation-scope reference is accepted (strict scope-policy violation, not a false-theorem claim) |
| M05 | Wrong assumption discharge admits false `not(1>0)` |
| M06 | Forged positivity `0>0` is accepted |
| M07 | Trailing input is accepted |
| M08 | Recycled assumption identities revive an out-of-scope assumption and admit false `not(1>0)` |

The mutant source and executable digests, baseline/mutant controls and diffs are
archived. No crash, failed build or signal counts as detecting these faults.
The decrement branch for indices above a removed binder is unreachable through
this closed-premise API; no claim is made of killing a mutant solely there.

## Preserved failed attempts and resource observations

A preliminary manifest check used the wrong working directory and failed before
execution. Initial suite builds with helper modules at project root failed
module resolution. Making functions public alone did not fix that layout.
Staging the unchanged helpers under `src/` resolved both imports. Independent
concatenation diagnostics failed and were not adopted. tests/TEST_ADJUSTMENTS.md
preserves initial manifests and explains these changes; expected cases and the
kernel were not altered to fit observations.

The root CLI's initial timing report shares its build-stderr receipt with
`time -v`; this is explicitly timing output, not compiler error output. Other
recorded builds separate time reports. Every run has separate application
stdout/stderr/exit receipts. Builds ran at nice19 on one CPU with at most 1 GiB
address space; runs used 256 MiB with CPU and wall timeouts. HOST_A host oom_kill
remained 1; HOST_B remained 14. These lifetime counters are not task failures.
The actual local cgroup counter snapshot is included; no pre/post cgroup delta
is claimed where only a final snapshot was collected.

## Acceptance still required

The proof is a concrete machine-checked derivation under the specified candidate
calculus. The mathematical soundness argument is reviewed prose, not a formal
metaproof of implementation/compilation correctness. PROOF_POLICY.md requires
owner/designated-verifier approval of the rules, axiom handling, syntax,
dependency closure, TCB and independent validation before authorizing
NATIVE_VERIFIED. That approval and the enabling governance change have not
occurred; neither agent agreement nor these tests replaces them. Publication authorization for this separate artifact was subsequently granted;
see the root license and publication record. This benchmark makes no RH
progress claim and does not change RH status.

Historical development-repository governance passed over the complete staged file index and actual
project commit history, with `NATIVE_VERIFIED_ACCEPTANCE=DISABLED`. That private workflow lacked a dedicated runner. This historical receipt is
not a GitHub CI result for the separate public artifact repository.
