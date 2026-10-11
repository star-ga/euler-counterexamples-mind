# K5 native build and run

Author: STARGA Inc.

Start from the repository root on Linux x86-64. Use the exact historical
compiler `a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa`
and LLVM/MLIR/Clang 20.1.8. Another qualified compiler profile requires its own
recorded run. The generic kernel source is unchanged. Build in separate scratch
projects so that each project contains exactly one main function.

```sh
set -eu
repo=$PWD
bench=$repo/benchmarks/euler_sum_of_powers_k5
compiler=/absolute/path/to/pinned/mindc
test "$(sha256sum "$compiler" | cut -d ' ' -f1)" = "$(cat "$repo/toolchain/compiler.sha256")"
(cd "$bench" && sha256sum -c PREEXECUTION.sha256)
scratch=$(mktemp -d)
cpu=$(awk '/Cpus_allowed_list:/ {split($2,a,/[-,]/); print a[1]}' /proc/self/status)
export MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt
export MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate
export CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang
for target in suite cli; do
  mkdir -p "$scratch/$target/src"
  cp "$bench/Mind.toml" "$scratch/$target/Mind.toml"
  cp "$repo/kernels/finite_nd/src/kernel.mind" "$scratch/$target/src/kernel.mind"
  cp "$bench/src/binding.mind" "$scratch/$target/src/binding.mind"
  if test "$target" = suite; then
    cp "$bench/src/main.mind" "$bench/src/fixtures.mind" "$scratch/$target/src/"
  else
    cp "$bench/cli/main.mind" "$scratch/$target/src/main.mind"
  fi
  (cd "$scratch/$target" && timeout 60 taskset -c "$cpu" nice -n 19 \
    prlimit --as=1073741824 --cpu=50 -- "$compiler" build src/main.mind \
    --backend mlir --target cpu --emit binary --optimize debug --no-cache --out check)
done
timeout 15 taskset -c "$cpu" nice -n 19 prlimit --as=268435456 --cpu=10 -- \
  "$scratch/suite/check"
timeout 15 taskset -c "$cpu" nice -n 19 prlimit --as=268435456 --cpu=10 -- \
  "$scratch/cli/check" < "$bench/certificates/P01_c5_refutation.nd.txt"
```

Both programs must exit normally with zero and empty application stderr. The
CLI must print `C5_BOUND_CERTIFICATE=PASS` and `FORMAL_ACCEPTANCE=BLOCKED`, each
LF-terminated. The suite prints per-fixture generic and bound outcomes and
finishes with exact counts and `K5_TESTS=PASS`. A crash, signal, failed build or
timeout cannot satisfy either result.

Additional predeclared CLI controls are B01 arithmetic-only, B06 valid-square
refutation, and N01 changed-witness certificate. Each must exit normally with
one, print `C5_BOUND_CERTIFICATE=FAIL` plus LF, and have empty stderr. These
controls exercise the stdin wrapper in addition to the embedded test harness.

Capture build/run commands, stdout, stderr, exit values, compiler/source/input
and executable hashes separately. Preserve failed attempts. Resource caps are
one CPU, 1 GiB address space per build, and 256 MiB per run. Use a quiet CPU,
low priority, and inspect host/cgroup memory and OOM counters before and after.

For root Make integration, add disjoint K5 suite and CLI build directories.
Copy the sources exactly as above; the generic kernel must come from
`kernels/finite_nd/src/kernel.mind`. Suggested targets are `k5-test` (suite)
and `k5-verify` (CLI fed P01). Existing K4 targets and compiler pins need no
changes. All executable mathematical and expected-outcome logic remains MIND;
shell and Make only assemble, invoke and record.
