#!/usr/bin/env bash
# Author: STARGA Inc. Build/receipt orchestration; mathematical decisions are MIND.
set -euo pipefail
umask 077
repo=$(realpath "$1")
compiler=$(realpath "$2")
scratch=$(realpath -m "$3")
cpu=${4:-6}
expected_compiler=${5:-c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5}
test ! -e "$scratch"
mkdir -p "$scratch/receipts" "$scratch/builds"
package=$repo/kernels/polynomial_nd
receipts=$scratch/receipts
test "$(sha256sum "$compiler" | cut -d ' ' -f1)" = "$expected_compiler"
printf 'compiler=%s\ncompiler_sha256=%s\nsource=%s\ncpu=%s\n' "$compiler" "$expected_compiler" "$repo" "$cpu" > "$receipts/config.txt"
cp "$package/tests/CASES.tsv" "$receipts/CASES.prelisted.tsv"
(cd "$repo" && find kernels/polynomial_nd/src kernels/polynomial_nd/tests kernels/polynomial_nd/certificates kernels/finite_nd/tests -type f -print0 | LC_ALL=C sort -z | xargs -0 sha256sum) > "$receipts/INPUTS.sha256"
sha256sum "$receipts/CASES.prelisted.tsv" > "$receipts/CASES.prelisted.sha256"
printf 'KERNEL_CHECK=PASS\n' > "$receipts/accept.stdout"
printf 'KERNEL_CHECK=FAIL\n' > "$receipts/refuse.stdout"
clean=(env -i PATH=/usr/bin:/bin LC_ALL=C LANG=C MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang)
sha256sum "$compiler" /usr/lib/llvm-20/bin/mlir-opt /usr/lib/llvm-20/bin/mlir-translate /usr/lib/llvm-20/bin/clang > "$receipts/TOOLS.sha256"
run() {
  local label=$1 cwd=$2 cap=$3 input=$4 expected=$5
  shift 5
  local base=$receipts/$label rc
  {
    printf 'cwd=%q\nstdin=%q\ncommand=' "$cwd" "$input"
    printf '%q ' "${clean[@]}" /usr/bin/time -v -o "$base.time" taskset -c "$cpu" nice -n 19 timeout 600 prlimit "--as=$cap" --core=0 -- "$@"
    printf '\n'
  } > "$base.command"
  set +e
  (cd "$cwd" && "${clean[@]}" /usr/bin/time -v -o "$base.time" taskset -c "$cpu" nice -n 19 timeout 600 prlimit "--as=$cap" --core=0 -- "$@") < "$input" > "$base.stdout" 2> "$base.stderr"
  rc=$?
  set -e
  printf '%s\n' "$rc" > "$base.exit"
  printf '%s exit=%s expected=%s\n' "$label" "$rc" "$expected"
  test "$rc" = "$expected"
  test ! -s "$base.stderr"
}
for name in main resource cache; do
  project=$scratch/builds/$name
  mkdir -p "$project/src"
  cp "$package/tests/Mind.toml" "$project/Mind.toml"
  cp "$package/tests/$name.mind" "$project/src/main.mind"
  cp "$package/tests/fixtures.mind" "$project/src/fixtures.mind"
  cp "$repo/kernels/finite_nd/tests/fixtures.mind" "$project/src/legacy_fixtures.mind"
  cp "$package/src/kernel.mind" "$project/src/kernel.mind"
  run "$name-build" "$project" 1073741824 /dev/null 0 "$compiler" build src/main.mind --backend mlir --target cpu --emit binary --optimize debug --no-cache --out "$project/check"
  sha256sum "$project/check" > "$receipts/$name-executable.sha256"
  run "$name-run" "$project" 268435456 /dev/null 0 "$project/check"
  cmp "$receipts/$name-run.stdout" "$package/evidence/public-source/$name/run.stdout"
done
project=$scratch/builds/cli
mkdir -p "$project/src"
cp "$package/Mind.toml" "$project/Mind.toml"
cp "$package/src/"*.mind "$project/src/"
run cli-build "$project" 1073741824 /dev/null 0 "$compiler" build src/main.mind --backend mlir --target cpu --emit binary --optimize debug --no-cache --out "$project/check"
sha256sum "$project/check" > "$receipts/cli-executable.sha256"
printf 'index\tname\texpected_accept\texit\tstdout_sha256\tstderr_sha256\n' > "$receipts/CORPUS_RESULTS.tsv"
total=0; accepts=0; refusals=0
while IFS=$'\t' read -r index name expected; do
  case "$expected" in
    1) exit_code=0; expected_output=$receipts/accept.stdout; accepts=$((accepts+1));;
    0) exit_code=1; expected_output=$receipts/refuse.stdout; refusals=$((refusals+1));;
    *) exit 96;;
  esac
  run "$name" "$project" 268435456 "$package/certificates/$name.nd.txt" "$exit_code" "$project/check"
  cmp "$receipts/$name.stdout" "$expected_output"
  printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$index" "$name" "$expected" "$exit_code" "$(sha256sum "$receipts/$name.stdout" | cut -d ' ' -f1)" "$(sha256sum "$receipts/$name.stderr" | cut -d ' ' -f1)" >> "$receipts/CORPUS_RESULTS.tsv"
  total=$((total+1))
done < "$receipts/CASES.prelisted.tsv"
test "$total" = 54; test "$accepts" = 16; test "$refusals" = 38
(cd "$repo" && sha256sum -c "$receipts/INPUTS.sha256") > "$receipts/inputs-after.stdout"
sha256sum -c "$receipts/TOOLS.sha256" > "$receipts/tools-after.stdout"
sha256sum -c "$receipts/CASES.prelisted.sha256" > "$receipts/cases-after.stdout"
printf 'POLYNOMIAL_CORPUS=PASS total=%s accepted=%s refused=%s execution_failures=0\n' "$total" "$accepts" "$refusals"
