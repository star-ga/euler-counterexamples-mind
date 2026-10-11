#!/usr/bin/env bash
set -u
cd /work/audit || exit 2
compiler=${1:-/work/compiler/initial/mindc}
label=${2:-initial}
sha256sum "$compiler" src/main.mind src/kernel.mind Mind.toml CASES.tsv > "evidence/$label-identities.sha256"
env MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang \
  taskset -c 7 nice -n 19 prlimit --as=1073741824 --cpu=180 -- \
  timeout 240 /usr/bin/time -v -o "evidence/$label-build.time" \
  "$compiler" build src/main.mind --backend mlir --target cpu --emit binary --optimize debug --no-cache --out "check-$label" \
  > "evidence/$label-build.stdout" 2> "evidence/$label-build.stderr"
build_rc=$?
printf '%s\n' "$build_rc" > "evidence/$label-build.exit"
if [ "$build_rc" -ne 0 ]; then exit "$build_rc"; fi
file "check-$label" > "evidence/$label-elf.txt"
sha256sum "check-$label" >> "evidence/$label-identities.sha256"
taskset -c 7 nice -n 19 prlimit --as=268435456 --cpu=120 -- \
  timeout 150 /usr/bin/time -v -o "evidence/$label-run.time" "./check-$label" \
  > "evidence/$label-run.stdout" 2> "evidence/$label-run.stderr"
run_rc=$?
printf '%s\n' "$run_rc" > "evidence/$label-run.exit"
exit "$run_rc"
