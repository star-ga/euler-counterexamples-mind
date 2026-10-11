# Executed command receipt

Author: STARGA Inc.

Execution root: `/BUILD_TMP/euler-nd-integration-20261011`. The source checkout was
`/BUILD_REPOSITORY`. The compiler was
`/PINNED_TOOLCHAIN/mindc`.
Environment overrides for all builds were:

```
MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt
MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate
CLANG=/usr/lib/llvm-20/bin/clang
CC=/usr/lib/llvm-20/bin/clang
```

Each build ran from its independent scratch project with the manifest at root
and main/helpers in src, using:
`timeout 60 taskset -c CPU nice -n 19 prlimit --as=1073741824 --cpu=50 -- COMPILER
build src/main.mind --backend mlir --target cpu --emit binary --optimize debug
--no-cache --out ABSOLUTE_ELF`. CPU0 was used for CLI/mutants; CPU1 for the
root's final main suite and regression. `/usr/bin/time -v -o RECEIPT` recorded
resources, except the first CLI build whose timing was captured in build.stderr.
The initial two failed main-suite attempts used a root-level main.mind and
are preserved explicitly; that layout is not the reproduction instruction.

Runtime commands used `timeout 15 taskset -c CPU nice -n 19 prlimit
--as=268435456 --cpu=10 -- ELF`. The generic CLI receives exactly one certificate
on stdin; the main suite embeds its static MIND fixtures and takes no input.
The unchanged earlier regression uses its documented stdin/fd3/fd4/fd5 streams.
For each mutant M01..M08, an independent CLI project copied the exact baseline
source and applied the matching tests/mutations diff with
`patch --batch --fuzz=0 -p1` from src. The exact positive/bad fixture mapping is
in tests/MUTATION_CONTRACT.md. Public .stdout/.stderr/.exit copies preserve application outcomes, but local
paths and host aliases in metadata have been redacted. They are not byte-identical
raw originals; see publication/README.md at the repository root.

The second-machine check transferred the CLI ELF and exact P01 certificate
into a new private scratch directory on HOST_B, checked both hashes, and ran the
same bounded CPU command under `env -i PATH=/usr/bin:/bin`. The first combined
transport receipt includes SSH warnings; separate host-b-proof.stdout/.stderr/.exit
files record the application's streams alone. No compiler was substituted.

The initial preexecution-wrong-cwd.stdout is a failed manifest check made from
the tests subdirectory. No compiler or kernel executed as part of that failure.
Successful preexecution-final-check.stdout was made from the package root.
Historical manifest copies and failed import-layout builds are retained rather
than replacing their observations with later passing outputs.
