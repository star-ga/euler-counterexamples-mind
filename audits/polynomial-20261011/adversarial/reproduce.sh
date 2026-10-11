#!/usr/bin/env bash
# Fresh reproduction transport. Every test decision is inside the MIND harness.
set -euo pipefail
if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  printf 'Usage: bash reproduce.sh /absolute/path/to/mindc /new/workspace [cpu]\n' >&2
  exit 2
fi
package_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
compiler=$(realpath -- "$1")
workspace=$(realpath -m -- "$2")
cpu=${3:-7}
if [ -e "$workspace" ]; then
  printf 'Workspace must not already exist: %s\n' "$workspace" >&2
  exit 2
fi
printf '%s  %s\n' c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5 "$compiler" | sha256sum -c -
mkdir -p -- "$workspace"
for label in final initial; do
  project="$workspace/$label"
  mkdir -p -- "$project/src" "$project/evidence"
  cp -- "$package_dir/Mind.toml" "$project/Mind.toml"
  cp -- "$package_dir/src/kernel.mind" "$project/src/kernel.mind"
  if [ "$label" = final ]; then
    cp -- "$package_dir/src/main.mind" "$project/src/main.mind"
  else
    cp -- "$package_dir/archive/main.initial.mind" "$project/src/main.mind"
  fi
  cd -- "$project"
  sha256sum "$compiler" Mind.toml src/*.mind > evidence/identities.sha256
  set +e
  env MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang \
    taskset -c "$cpu" nice -n 19 prlimit --as=1073741824 --cpu=180 -- \
    timeout 240 /usr/bin/time -v -o evidence/build.time \
    "$compiler" build src/main.mind --backend mlir --target cpu --emit binary --optimize debug --no-cache --out check \
    > evidence/build.stdout 2> evidence/build.stderr
  build_rc=$?
  set -e
  printf '%s\n' "$build_rc" > evidence/build.exit
  if [ "$build_rc" -ne 0 ]; then exit "$build_rc"; fi
  file check > evidence/elf.txt
  sha256sum check >> evidence/identities.sha256
  set +e
  taskset -c "$cpu" nice -n 19 prlimit --as=268435456 --cpu=120 -- \
    timeout 150 /usr/bin/time -v -o evidence/run.time ./check \
    > evidence/run.stdout 2> evidence/run.stderr
  run_rc=$?
  set -e
  printf '%s\n' "$run_rc" > evidence/run.exit
  if [ "$run_rc" -ne 0 ]; then exit "$run_rc"; fi
done
