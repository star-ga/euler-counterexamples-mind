# Polynomial qualification with the public-source compiler

Author: STARGA Inc.
Date: 2026-10-11
Result: **PASS — three harnesses, 326 checker calls, 28 accepts, 298 rejects.**

Compiler SHA-256:
`c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5`.
Compiler source/build recipe: [existing public bootstrap profile](../../../../toolchain/public-source/README.md).
Kernel SHA-256:
`7eed71f7cb06715744471edf80da5b6b1f3cdadb2ba345e3605814d2951fa3e2`.
The existing already-built compiler was hash-verified; no compiler build,
installation, pin change or compiler source modification was performed.

The exact exported main/resource/cache sources were built independently with
LLVM/MLIR/Clang 20.1.8. All six build/run stages exited 0; stderr was empty.
Each harness stdout matched its final historical expected output byte-for-byte.
The main harness has 24 initially counted accepts plus one separately labeled
restored-input acceptance. The call totals below account for that extra call.

| Harness | Calls | Accepts | Rejects | Build/run exits | Build/run seconds | Build/run max RSS KiB | ELF SHA-256 |
|---|---:|---:|---:|---|---|---|---|
| `main` | 321 | 25 | 296 | 0 / 0 | 6.003 / 1.001 | 149,236 / 3,724 | `33ede8b8c6480d6587294f3c2b3382d41e133e6bb42eccd326b90b0f2f8c5f81` |
| `resource` | 2 | 1 | 1 | 0 / 0 | 6.002 / 1.001 | 149,952 / 3,688 | `ea7abfa65a127b72abca744a2b497535aae5914632d79267c5a2d04161af9085` |
| `cache` | 3 | 2 | 1 | 0 / 0 | 6.002 / 1.001 | 149,896 / 2,320 | `02b99f06802a5088bab64e6f72ba081bc4cde76ac431ddd6e36f3bafd7d79d1d` |

Commands, environment/tool digests, input hashes, stdout/stderr, exit values,
GNU Time measurements and sampled host-memory availability are retained here.
Local paths were replaced with `/work/qualification` and `/work/toolchain/mindc`;
these are declared export placeholders. Original stream digests are retained in
`stdout_sha256`/`stderr_sha256`; added `exported_stdout_sha256` and
`exported_stderr_sha256` bind the sanitized stream files. `EXPORT_FILES.tsv`
records original/export hashes for every fresh receipt. Timing includes the one-second monitor
sampling interval. Each stage used CPU 6, nice 19, a 600-second wall deadline,
unlimited CPU-time allowance, 1 GiB build address space and 256 MiB run address
space. No timeout, memory-floor stop or host OOM-counter increment occurred.
See [the reproduction commands](../../REPRODUCE.md).

This profile qualifies only these three harnesses on this Linux x86-64 host.
The extension's 12-mutation campaign, full standalone-CLI corpus, LLVM 23 and
direct-native compatibility runs were not repeated with this compiler. Their
historical receipts remain labeled by their original compiler. These runs are
engineering evidence, not a soundness metatheorem, a new cross-host claim,
formal acceptance or publication authorization. Existing PQC signatures cover
their original manifests only and do not cover this new extension.
