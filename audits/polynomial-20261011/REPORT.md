# Independent polynomial-kernel audit

Author: STARGA Inc.
Date: 2026-10-11

Audited public commit: `cacb9492a0c356dd094d08972910fda9232b4472`.
Kernel SHA-256: `7eed71f7cb06715744471edf80da5b6b1f3cdadb2ba345e3605814d2951fa3e2`.
The mathematical checker, all 54 certificates, and the original test contract
remain unchanged. No confirmed false-theorem acceptance or implementation defect
was found in `POLY_ID`. This is a bounded review result, not proof of bug absence.

## Fresh compiler build and execution

The documented public compiler source was anonymously fetched at
`5724a6ee44cc37fa6e432bf5fc237ef1b70e9624`, tree
`3472648d8590d2a50b56b8160565c066324509b1`. The supplied Cargo.lock remained
`3466f1a6ee2c325226c152f9022b72b4b39e86fc474bb9a40f5e01ecb75d4c6f`.
Rust/Cargo 1.98.0, original release settings, and the documented three features
were used with a fresh target, read-only source/registry mounts, and no build
network. No compiler source or shared installation was modified.

Build exited 0 in **4m08.99s**, reproducing compiler SHA-256
`c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5`.
One CPU, nice19, 2 GiB cgroup memory, zero swap and a 600-second deadline were
enforced. Cgroup peak reached 2,147,483,648 bytes; the last observed `max` counter
was 671 (memory-limit reclamation events), with **zero OOM and OOM-kill events**.
GNU time reported 2,015,160 KiB maximum RSS and zero swaps. These measurement
scopes differ. The host OOM-kill counter stayed 1. An initial monitor stopped
because copying sysfs metadata made its destination read-only; it was restarted
using plain content reads. The resource caps remained active throughout; the
sampling gap and both monitor files are retained. No zero-pressure claim is made.

The fresh compiler built all four polynomial executables through the documented
LLVM/MLIR20 CPU backend. The three MIND harnesses passed **326 calls**; all
**54 standalone certificates** matched the expected exit, stdout and stderr:
**16 accepts, 38 ordinary refusals, zero execution failures**. Build and run
stderr were empty. Successful build stdout contains ordinary compiler status.
All four executable hashes matched the earlier public profile:

| Executable | SHA-256 |
| --- | --- |
| Main harness | `33ede8b8c6480d6587294f3c2b3382d41e133e6bb42eccd326b90b0f2f8c5f81` |
| Resource harness | `ea7abfa65a127b72abca744a2b497535aae5914632d79267c5a2d04161af9085` |
| Cache harness | `02b99f06802a5088bab64e6f72ba081bc4cde76ac431ddd6e36f3bafd7d79d1d` |
| Generic certificate CLI | `c7a63b0503af8c338821c07ea9433f68c0545fa12699fbbda7706797d97a8ce8` |

This is a fresh source build on the same host/toolchain, not a second compiler
implementation or a cross-platform bit-identity guarantee. The historical
compiler pin is unchanged. The 12 historical checker mutations and LLVM23
comparison retain their historical scope; they were not rerun by this audit.

## Independent source and boundary review

[Source review](SOURCE_REVIEW.md) reconstructs the normalization argument for an
arbitrary assignment in Z^4. Exact coefficient addition/convolution preserve
polynomial denotation; the radix-33 digit checks make exponent encoding
injective; identical canonical lists therefore denote equal values for every
integer assignment. This is a symbolic argument, not extrapolation from sampled
values. Its assumptions include correct compiler/runtime behavior and exclusively
owned, valid, immutable input/workspace lifetimes as documented by the API.

The review checks parser bounds, all 12 coefficient limbs, carry propagation,
workspace disjointness, topological children, initialization before visibility,
cache reset, de Bruijn substitution, fresh assumption occurrences and discharge.
Every conclusion is tied to source lines in the pinned commit. It found no
concrete counterexample; its limitations and remaining obligations are explicit.

[Independent MIND tests](adversarial/REVIEW.md) add 82 API cases: 19 accepted
controls and 63 refusals, with zero mismatches after fresh-compiler rebuilding.
The first 64 cases were frozen before execution; 18 follow-up cases were separately
predeclared after source review. They exercise arithmetic and encoding boundaries,
zero/capacity behavior, malformed fields, substitution/scope and cache reuse.
All 80 calls with owned input preserved those input bytes. The final executable
was `2310b9b6e41eb9f0de7043e3afd7a77bf82aace98b06869521adb02524c70a1d`.
Two intermediate builds failed because an archived source remained under `src/`;
the archive was relocated and both failures retained. Neither counts as successful
fault detection. No expected result or checker rule changed.

The source and test reviewers were separate model-assisted sessions. These are
independent review activities within this project, **not human review, a
machine-checked metatheorem, or designated-verifier formal approval**.

## Reproduce and inspect

First build the compiler using [the public recipe](../../toolchain/public-source/README.md).
Then, from the repository root, with a new scratch directory:

```sh
bash audits/polynomial-20261011/reproduce-polynomial.sh \
  "$PWD" /absolute/path/to/rebuilt/mindc /tmp/euler-audit-replay 6
```

Choose an available CPU instead of 6. The script enforces the recorded compiler
hash and explicit backend. It freezes inputs before execution, stages each
project separately, bounds resources, retains commands/streams/exits, checks all
54 cases and rechecks input/tool hashes afterwards. The independent test package
has its own reproduction instructions. A different rebuilt compiler requires
new qualification; changing a pin alone is not qualification.

The contract and case lists precede their respective runs. Follow-up tests and
signing-wrapper findings are source-informed additions, not blinded tests.
`EXPORT_FILES.tsv` records raw/export hashes. Operational paths alone were
normalized to public placeholders, except removal of one unrelated memory-workflow
paragraph in the source report and (2026-10-28, before re-signing) of one
out-of-scope reference to unrelated private work in the contract; original
execution values and mathematical source are preserved. Historical receipt hashes,
including `FROZEN.sha256`, refer to pre-export bytes; use the local `SHA256SUMS`
for this published archive. No compiler ELF or private source is included.

## Signing and acceptance boundary

The [separate polynomial signing package](../../signing/polynomial/README.md)
binds this release and audit. Its execution report records actual signature
verification separately; a signature is provenance, not an endorsement of kernel
soundness. New wrapper review and corrections are documented in
`PROVENANCE_REVIEW.md`. The historical K4/K5 signed carrier, manifest and all
1,506 bound payload files remain byte-identical and separately verifiable.

**FORMAL_PROOF_SUBMITTED remains unchanged. Direct-native remains BLOCKED.**
The documented allocation-closure, modulo and printing failures were not resolved
by this MLIR replay. Substantive owner/designated-verifier approval under
`PROOF_POLICY.md`, and the source/compiler/semantic trust obligations, remain open.
No mathematical novelty or RH progress is claimed.
