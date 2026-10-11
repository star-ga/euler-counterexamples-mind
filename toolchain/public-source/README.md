# Qualified public-source compiler profile

Author: STARGA Inc.

The finite natural-deduction checker, its arithmetic, certificates and executable test decisions remain MIND. Compiler implementation and build tools are explicit trusted build infrastructure, not alternate theorem verifiers.

## Source and compiler identities

Public source: https://github.com/star-ga/mind/commit/5724a6ee44cc37fa6e432bf5fc237ef1b70e9624

Unauthenticated GitHub API HTTP 200 and a fresh unauthenticated Git fetch established public accessibility on 2026-10-11. Source commit: `5724a6ee44cc37fa6e432bf5fc237ef1b70e9624`; tree: `3472648d8590d2a50b56b8160565c066324509b1`.

The original source commit did not track Cargo.lock. The retained build lockfile supplied alongside this profile has SHA-256 `3466f1a6ee2c325226c152f9022b72b4b39e86fc474bb9a40f5e01ecb75d4c6f`; its dependency sources are crates.io registry entries, with no private Git dependencies. Preserve this lockfile and use --locked. Qualified build used existing downloaded registry dependencies mounted read-only, --offline, and a fresh isolated writable target directory.

Rust: `rustc 1.98.0 (88d9e12ae 2026-08-18)`; Cargo: `cargo 1.98.0 (797e8a9bc 2026-08-05)`.
Rustc executable SHA-256: `3690cc576ede140504698405d5d8fa3826aaadbe71699c6c4ed0a565d6f493e2`.
Cargo executable SHA-256: `ff3022fcbd13b08434ea7afde9a0ef9d5b3f5c17b5fc7a40031be3ee000a6a24`.

Build command:

```sh
CARGO_BUILD_JOBS=1 cargo build --release --bin mindc \
  --features 'std-surface mlir-build cross-module-imports' --locked --offline
```

No source changes or profile overrides were applied. The public source Cargo.toml release settings include LTO and codegen-units=1. Compiler build used one CPU, nice19, 2 GiB cgroup memory maximum, zero swap, and a 600-second timeout. Result: exit 0; 4m29.86s wall time; observed cgroup peak 2,065,399,808 bytes; zero observed max/OOM/kill events, service result success, host oom_kill unchanged. No limit increase was needed.

Fresh compiler SHA-256: `c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5`.

This is a separately qualified source-build profile. The historical canonical compiler remains `a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa`; it is not silently replaced. Compiler byte identity was not reproduced and is not claimed.

## Bootstrap recipe

With Git, Rust/Cargo 1.98.0, the supplied lockfile, and Linux x86-64 build prerequisites installed:

```sh
mkdir mind-public-source
cd mind-public-source
git init
git remote add origin https://github.com/star-ga/mind.git
git fetch --depth=1 origin 5724a6ee44cc37fa6e432bf5fc237ef1b70e9624
git checkout --detach FETCH_HEAD
# Copy the supplied profile Cargo.lock here without changing its bytes.
sha256sum Cargo.lock
# Required digest: 3466f1a6ee2c325226c152f9022b72b4b39e86fc474bb9a40f5e01ecb75d4c6f
rustc --version
cargo --version
# On a fresh machine first obtain the locked public dependencies:
cargo fetch --locked
CARGO_BUILD_JOBS=1 cargo build --release --bin mindc \
  --features 'std-surface mlir-build cross-module-imports' --locked --offline
sha256sum target/release/mindc
```

Run the build with a reviewed resource cap rather than changing shared compiler installations. The qualification used an empty environment, no network during compilation, read-only source/dependency mounts and a fresh target cache. This recipe is not a hermetic compiler bootstrap; other compiler bytes may result on a different build environment. Report the new digest and rerun all program qualification before accepting a new profile.

For compiling MIND programs, explicitly select LLVM/MLIR/Clang 20.1.8:

```sh
export MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt
export MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate
export CLANG=/usr/lib/llvm-20/bin/clang
export CC=/usr/lib/llvm-20/bin/clang
# From each fresh project root with Mind.toml and src/:
/path/to/rebuilt/mindc build src/main.mind --backend mlir --target cpu \
  --emit binary --optimize debug --no-cache --out /path/to/checker
readelf -h /path/to/checker
```

The compiler's public bundled runtime-support adapter is used; no external proprietary MIND runtime was selected. This is a native ELF built through MLIR, not an MLIR-free build. Builds were capped at one CPU, nice19, 1 GiB address space, 50 CPU seconds and 60 wall seconds. Native runs used 256 MiB, 10 CPU seconds and 15 wall seconds. The four-call qualification unit used 2 GiB physical memory, zero swap and one CPU; peak 115,671,040 bytes and zero cgroup OOM events.

## Observed unchanged-program qualification

| Program | Build / run exits | Observed result | Executable SHA-256 |
|---|---|---|---|
| Generic CLI, exact Euler certificate | 0 / 0 | KERNEL_CHECK=PASS LF | 133bee11b6f30f0be9b72ff8a6a05aef19d8d1bc3dcdd8183f1050262b8dd47d |
| Main finite ND suite | 0 / 0 | 8 initial accepts, 1585 rejects, restored Euler PASS | 59b9f31e9f986a27327fbe387f71e630ac3607037011bec5d4c7b9dbe3be03d0 |
| Independently authored 33-case harness | 0 / 0 | 33 expected results, zero failures | 426668759061969baa10cfaac11495f3da2b6de52c888296e2dc1b12153a3dba |
| Original four-stream benchmark | 0 / 0 | arithmetic/template PASS, 1240 negative checks | db4dbb31a1d38091f870e0686acd1c35bb191e6161533e612b082986e584abf1 |

All application stdout matched the historical recorded output byte-for-byte; application/build stderr were empty. All four ELFs were byte-identical to the corresponding historical a1444-built artifacts. These are observations on one host/backend configuration; no cross-platform identity or independent compiler implementation is claimed. Source/certificate/expected-output hashes were frozen before execution and rechecked afterwards. Original formal-acceptance flags stayed blocked; test success alone does not promote proof status. Mutation qualification is a separate owner-run lane, not included in this four-program claim.

## Public release binary diagnostic

The official v0.10.2 release at https://github.com/star-ga/mind/releases/tag/v0.10.2 contains linux-x64 archive SHA-256 `0c8beb4464f8c7d638a81c2dd8ad5eac81a0ddbc7556be711f00e029d01ef258`; its published checksum and GitHub digest matched. Extracted compiler SHA-256 is `3d54874dfc4b9a208ac46be8a0f3959a148cba801d65f623ac6534129cf1e140`.

That executable is not a usable substitute for this profile: the correct project-root build resolved both modules but exited 1 with missing CPU runtime. An explicit src/main.mind invocation also lost cross-module binding. No compatible external proprietary runtime was injected, no executable/test acceptance was claimed, and no canonical pin changed. Use the qualified public-source build above.

## Distribution boundary

No compiler binary or private compiler source needs redistribution. The public MIND runtime-support source at the pinned revision is Apache-2.0 with STARGA attribution. The verifier ELF also contains standard startup/CPU support and dynamically requires libc.so.6/libm.so.6 and /lib64/ld-linux-x86-64.so.2, with symbol requirements through GLIBC_2.34. If distributing an ELF, preserve its applicable runtime/third-party notices rather than describing the entire binary as exclusively STARGA-authored. This profile records technical provenance and tested build behavior; it does not itself select a publication license.
