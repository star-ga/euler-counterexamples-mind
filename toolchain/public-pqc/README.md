# Public-source PQC signing and verification profile

Author: STARGA Inc.

This profile builds the public MIND compiler's cryptographic evidence facility. The mathematical implementation and executable test decisions remain MIND. The compiler, its cryptographic libraries and build tools are explicit infrastructure; a valid signature authenticates bound artifact bytes and does not establish mathematical soundness or native-ELF equivalence.

## Exact source and configuration

Public source commit: `5724a6ee44cc37fa6e432bf5fc237ef1b70e9624` at https://github.com/star-ga/mind/commit/5724a6ee44cc37fa6e432bf5fc237ef1b70e9624 . Tree: `3472648d8590d2a50b56b8160565c066324509b1`.

Retained Cargo.lock SHA-256: `3466f1a6ee2c325226c152f9022b72b4b39e86fc474bb9a40f5e01ecb75d4c6f`. The source revision did not track this lockfile; use the supplied exact lockfile with --locked. Registry dependencies are public crates.io packages, with no private Git dependency. The cryptographic dependencies are fips2040.4.6 (ML-DSA-87 support), fips2050.4.1 (SLH-DSA-SHAKE-256s), and rand_core0.6.4.

Rust: `rustc1.98.0 (88d9e12ae 2026-08-18)`, executable SHA-256 `3690cc576ede140504698405d5d8fa3826aaadbe71699c6c4ed0a565d6f493e2`.
Cargo: `cargo1.98.0 (797e8a9bc 2026-08-05)`, executable SHA-256 `ff3022fcbd13b08434ea7afde9a0ef9d5b3f5c17b5fc7a40031be3ee000a6a24`.

Exact requested features: `std-surface mlir-build cross-module-imports evidence-mldsa evidence-slhdsa`.
The Cargo.toml release profile was unchanged: LTO=true and codegen-units=1. No RUSTFLAGS/profile override was applied. Matching Cargo fingerprint SHA-256: `4d37b851bee04ed80ce04ba8f295f41bdfb9d38529ff7899cc06cd752f6d345e`.

Build command:

```sh
CARGO_BUILD_JOBS=1 cargo build --release --bin mindc \
  --features 'std-surface mlir-build cross-module-imports evidence-mldsa evidence-slhdsa' \
  --locked --offline
```

On a fresh machine first obtain the locked public dependencies with `cargo fetch --locked`; then use the offline build command above. Use a separate target directory. This is a reproducible source/configuration recipe, not a demonstrated bit-identical compiler bootstrap across machines.

## Observed build

Fresh executable SHA-256: `1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e`.

Observed release build: exit0, 5m00.65s wall time. Build used one CPU, nice19, cgroup2GiB memory maximum, zero swap,600s timeout, isolated fresh target/cache, read-only source and downloaded registry packages, and no network or credentials. Observed cgroup peak2,097,106,944bytes; memory max/OOM/kill counters all0. A sampled own-job guard was present but did not fire. GNU time reported maximum RSS2,052,352KiB and zero swaps; these measurements have distinct scopes. No debug fallback or memory-limit change was used.

The compiler reports mind0.10.2/core-ir1.0. It is an x86-64 ELF and dynamically requires libc.so.6 and libgcc_s.so.1, with GLIBC symbols through2.39. This compiler ELF cannot simply be replayed on a glibc2.34 host; build the public-source profile in a compatible environment instead. This limit is distinct from the four proof executables' GLIBC2.34 requirement. Build-tool and ELF-dependency receipts are retained separately. The historical a1444 compiler and separately qualified c6a4 compiler remain unchanged. The four proof executables retain their previously recorded hashes; they were not rebuilt with this signing profile.

## Evidence compatibility controls

The existing two-attribute unsigned carrier has SHA-256 `8a41f7f269f6377103397067e3a9a6dd31c7648075ce63df2652c5925f4b01ea` and MIC3 revision0x02.

| Observation | Exit | Result |
|---|---:|---|
| Plain JSON verification | 0 | Valid trace hash/SSA, signature absent, provenance_authenticated=false |
| Same bytes with --require-signed | 1 | Explicit refusal because no valid signature is present |

The new executable exposes --evidence-attr and repeatable --signer-pubkey options. Its pinned public source supports MIC3 revision0x02/0x03 and the draft0x04 codec. Compiled capability and unsigned compatibility alone are not a signed-artifact acceptance result. The nine separately prelisted signed-artifact controls are recorded in SIGNATURE_CONTROLS.md; they are diagnostic fixtures, not a release signature.

For actual authenticity, verify with --require-signed and both expected public-key pins, then independently enforce the intended two-leg scheme and bound manifest identity. A newly introduced project signing key does not automatically constitute an organization-wide trust root. No private signing key or proprietary compiler binary belongs in the public proof package.
