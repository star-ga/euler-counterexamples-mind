# Reproduce the native campaign

Author: STARGA Inc.

Use Linux x86-64 with the exact installed compiler, at least 8 GiB available
memory and the recorded backend tools. No downloads, pin changes or shared
configuration changes are implicit. Inspect system and actual process-cgroup
OOM counters before and after. Shell below only assembles source variants,
invokes native executables and collects receipts; all test decisions are MIND.

From the repository root:

```bash
set -eu
repo=$PWD
bench=$repo/benchmarks/euler_sum_of_powers_k4
compiler=$(readlink -f "$(command -v mindc)")
test "$(sha256sum "$compiler" | cut -d ' ' -f1)" = "$(cat toolchain/compiler.sha256)"
(cd "$bench" && sha256sum -c SHA256SUMS && cd evidence && sha256sum -c SHA256SUMS)
test "$(awk '/MemAvailable:/{print $2}' /proc/meminfo)" -ge 8388608
scratch=$(mktemp -d)
mkdir -p "$scratch/tmp" "$scratch/cache" "$scratch/receipts"
export TMPDIR="$scratch/tmp" XDG_CACHE_HOME="$scratch/cache"
export MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt
export MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate
export CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang
# CPU 0 was used in the recorded run; choose an allowed CPU on your host.
cpu=0
for variant in baseline positivity recomputation binding eof; do
  for program in main mutation_probe; do
    label=$variant-$program
    project=$scratch/$label-project
    mkdir -p "$project/src"
    cp "$bench/Mind.toml" "$project/Mind.toml"
    cp "$bench/src/checker.mind" "$project/src/checker.mind"
    if test "$program" = main; then
      cp "$bench/src/main.mind" "$project/src/main.mind"
    else
      cp "$bench/supplemental/main.mind" "$project/src/main.mind"
    fi
    if test "$variant" != baseline; then
      (cd "$project/src" && patch --batch --fuzz=0 -p0 < "$bench/mutations/$variant.diff.txt")
    fi
    # Working directory and one entry point per project are required.
    set +e
    (cd "$project" && timeout 60 taskset -c "$cpu" nice -n 19 \
      prlimit --as=1073741824 --cpu=50 -- "$compiler" build src/main.mind \
      --backend mlir --target cpu --emit binary --optimize debug --no-cache \
      --out "$scratch/$label") \
      > "$scratch/receipts/$label-build.stdout" 2> "$scratch/receipts/$label-build.stderr"
    build_exit=$?
    set -e
    printf '%s\n' "$build_exit" > "$scratch/receipts/$label-build.exit"
    test "$build_exit" -eq 0
    sha256sum "$scratch/$label" >> "$scratch/receipts/executables.sha256"
    set +e
    timeout 15 taskset -c "$cpu" nice -n 19 prlimit --as=268435456 --cpu=10 -- \
      "$scratch/$label" < "$bench/arithmetic.txt" 3< "$bench/refutation.txt" \
      4< "$bench/zero-arithmetic.txt" 5< "$bench/zero-refutation.txt" \
      > "$scratch/receipts/$label-run.stdout" 2> "$scratch/receipts/$label-run.stderr"
    run_exit=$?
    set -e
    printf '%s\n' "$run_exit" > "$scratch/receipts/$label-run.exit"
  done
done
```

Interpret outputs using MUTATION_CONTRACT.md and RESULTS.md, including normal
exit codes, every acceptance field and successful positive/restoration controls.
A nonzero exit alone is not sufficient. The recomputation mutant's original
harness intentionally demonstrates a surviving fault; it is not a passing
mutation-detection result. Record raw commands/environment, versions, hashes,
stdout, stderr, exit codes and resources before reporting any new result.

The archived governance runs belonged to the original development campaign.
This separate public repository does not include that unrelated governance
program. Its exported sources and evidence are checked with the release and
source manifests; formal acceptance remains governed by the root PROOF_POLICY.md.
