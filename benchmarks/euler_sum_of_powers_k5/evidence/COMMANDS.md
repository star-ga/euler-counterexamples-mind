# K5 execution receipt

Author: STARGA Inc.

The exact source assembly and fixed call order are documented in
`../REPRODUCE.md` and `../TEST_CONTRACT.md`. Two fresh projects were built:

- Suite: `Mind.toml`, `src/main.mind`, `src/fixtures.mind`,
  `src/binding.mind`, and the unchanged central `src/kernel.mind`.
- CLI: the same manifest and binding/kernel, with `cli/main.mind` copied to
  `src/main.mind`; no fixtures module was required.

The compiler executable was checked against the canonical SHA-256 before any
source check/build. The 53-entry pre-execution manifest was verified before
the builds and again after all five process runs. Each child received an empty
environment apart from `PATH=/usr/bin:/bin`, `LC_ALL=C`, and, for builds only,
the compiler path and explicit backend variables:

```text
MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt
MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate
CLANG=/usr/lib/llvm-20/bin/clang
CC=/usr/lib/llvm-20/bin/clang
```

From each project root, first the bounded source check ran:

```sh
timeout 60 taskset -c 2 nice -n 19 prlimit --as=1073741824 --cpu=50 -- \
  "$MINDC" check --no-fmt --no-lint src
```

Then the native build ran:

```sh
timeout 60 taskset -c 2 nice -n 19 prlimit --as=1073741824 --cpu=50 -- \
  "$MINDC" build src/main.mind --backend mlir --target cpu \
  --emit binary --optimize debug --no-cache --out check
```

Each run used `timeout 15 taskset -c 2 nice -n 19 prlimit --as=268435456
--cpu=10 -- ./check`. The suite received `/dev/null`; CLI inputs, in order,
were P01, B01, B06 and N01 as listed in the frozen contract.
`/usr/bin/time -v -o LABEL.time.txt` recorded resources separately from
application stdout/stderr. Every stage has an explicit decimal-LF exit receipt.
The native source/kernel/certificate bytes are in the pre-execution manifest;
compiler, executable and backend/runtime hashes accompany these observations.

The raw receipts contain no private machine names or access routes. The
compiler path is represented by the shell variable `$MINDC` in timing output;
its exact executable identity is `compiler.sha256`. No application outcome,
error, time or resource value was rewritten. The original failed unstaged
source check is preserved separately and is not counted as a native test.
