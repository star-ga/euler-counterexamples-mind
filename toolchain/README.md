# Compiler and build dependencies

Author: STARGA Inc.

**A public-source build is now qualified.** Follow the tested
[bootstrap profile](public-source/README.md), including its pinned Cargo.lock.
That fresh compiler has SHA-256
`c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5`.
It built and ran all four unchanged programs; their executable bytes and
stdout/stderr/exit values matched the historical artifacts. This does not
claim compiler byte identity or a hermetic toolchain bootstrap.

The historical verification used official MIND 0.10.2, compiler SHA-256
`a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa`.
That digest remains in `compiler.sha256`. It was built locally from public
[source commit 5724a6ee44cc37fa6e432bf5fc237ef1b70e9624](https://github.com/star-ga/mind/commit/5724a6ee44cc37fa6e432bf5fc237ef1b70e9624),
using features `std-surface mlir-build cross-module-imports`.
The original compiler executable has no demonstrated public release download.
Its source-build recipe is not, by itself, a claim of compiler byte identity.

The public v0.10.2 release executable has a different digest,
`3d54874dfc4b9a208ac46be8a0f3959a148cba801d65f623ac6534129cf1e140`.
It is not interchangeable with the historical pin. A bounded test of its
documented MLIR CPU build failed with a missing CPU runtime; that attempt is
not a successful reproduction and no replacement runtime is invented here.

The working historical backend used LLVM/MLIR/Clang 20.1.8, with
`MLIR_OPT`, `MLIR_TRANSLATE`, `CLANG` and `CC` pointing to the corresponding
installed tools. It produces a native ELF through MLIR, not through MIND's
separate experimental native emitter. The executable uses system libc/libm and
the Linux x86-64 loader. These dependencies and the compiler remain in the TCB.

No compiler binary, system library, secret signing key or licensed commercial
mathematics software is included. Signing is optional; evidence signatures,
when present, concern integrity and provenance rather than logical soundness.
Any newly tested public-source bootstrap profile must carry its own compiler
digest and evidence without replacing the historical results.
