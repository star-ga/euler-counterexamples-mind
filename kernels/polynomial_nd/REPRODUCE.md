# Reproduce the symbolic extension

Author: STARGA Inc.

Use Linux x86-64 and the separately qualified public-source compiler described
in [the public bootstrap profile](../../toolchain/public-source/README.md).
Its compiler SHA-256 is
`c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5`.
The [extension qualification](evidence/public-source/RESULTS.md) records the same
326 calls on this exact compiler. A later
[public-download replay](evidence/public-replay/RESULTS.md) repeated those
harnesses and checked all 54 standalone CLI certificates. Obtain the compiler
by the public source/lockfile recipe;
no compiler binary is redistributed here. Record your actual compiler digest.
A different rebuild digest requires its own qualification before adoption.

The [independent audit](../../audits/polynomial-20261011/REPORT.md) rebuilt this
compiler from anonymously fetched public source into an empty target directory,
reproduced its digest, and repeated all three harnesses and the 54-certificate
corpus. Its receipt-producing replay script and independent MIND tests are
available with that report. This is same-host reproducibility, not a second
compiler implementation or cross-platform guarantee.

The historical receipts retain compiler digest `a1444e44...ffa`; the repository's
existing `toolchain/compiler.sha256` is unchanged. That older binary is not a
prerequisite for the newly qualified public-source route. LLVM/MLIR/Clang 20.1.8
and the public runtime-support adapter remain explicit build dependencies.
The commands stage sources and collect receipts; mathematical decisions reside
in the MIND executables. Choose an available host CPU. Builds use 1 GiB address
space; runs use 256 MiB; each stage has a 600-second wall deadline. Resource
failure is not a proof rejection.

Run from the repository root:

```bash
set -eu
repo=$PWD
package=$repo/kernels/polynomial_nd
compiler=/absolute/path/to/public-source/mindc
test "$(sha256sum "$compiler" | cut -d ' ' -f1)" = "c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5"
(cd "$package" && sha256sum -c SHA256SUMS)
scratch=$(mktemp -d)
cpu=$(awk '/Cpus_allowed_list:/{split($2,a,/[-,]/); print a[1]}' /proc/self/status)
export MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt
export MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate
export CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang
mkdir -p "$scratch/cli/src"
cp "$package/Mind.toml" "$scratch/cli/Mind.toml"
cp "$package/src/"*.mind "$scratch/cli/src/"
(cd "$scratch/cli" && timeout 600 taskset -c "$cpu" nice -n 19 \
  prlimit --as=1073741824 --cpu=unlimited -- "$compiler" build src/main.mind \
  --backend mlir --target cpu --emit binary --optimize debug --no-cache \
  --out "$scratch/check")
readelf -h "$scratch/check"
for name in P01_binomial P02_scaled_k4; do
  timeout 600 taskset -c "$cpu" nice -n 19 \
    prlimit --as=268435456 --cpu=unlimited -- "$scratch/check" \
    < "$package/certificates/$name.nd.txt"
done
```

Each positive invocation must exit 0, print exactly `KERNEL_CHECK=PASS` followed
by LF and produce empty stderr. This indicates acceptance of the goal encoded
in those certificate bytes. A filename or a supplied PASS string is not trusted.
An invalid certificate normally prints `KERNEL_CHECK=FAIL` and exits 1; exit 2,
signals, crashes and timeouts are execution failures.

The two commands above demonstrate the named identities. For the full CLI
corpus, run that same invocation for every certificate in `tests/CASES.tsv`;
the third column is the expected acceptance (1 accepts, 0 refuses). The
[public replay table](evidence/public-replay/receipts/cli-cases-observed.tsv)
records all 54 expected exits and stream hashes: 16 accepts and 38 normal
refusals. Preserve the exact malformed bytes and count execution failures
separately from ordinary refusals.

Build each native test harness independently:

```bash
for name in main resource cache; do
  project=$scratch/$name
  mkdir -p "$project/src"
  cp "$package/tests/Mind.toml" "$project/Mind.toml"
  cp "$package/tests/$name.mind" "$project/src/main.mind"
  cp "$package/tests/fixtures.mind" "$project/src/fixtures.mind"
  cp "$repo/kernels/finite_nd/tests/fixtures.mind" "$project/src/legacy_fixtures.mind"
  cp "$package/src/kernel.mind" "$project/src/kernel.mind"
  (cd "$project" && timeout 600 taskset -c "$cpu" nice -n 19 \
    prlimit --as=1073741824 --cpu=unlimited -- "$compiler" build src/main.mind \
    --backend mlir --target cpu --emit binary --optimize debug --no-cache \
    --out "$project/check")
  timeout 600 taskset -c "$cpu" nice -n 19 \
    prlimit --as=268435456 --cpu=unlimited -- "$project/check"
done
```

Expected counts are in `tests/BUILD.md`; historical receipts are in
`tests/evidence/FINAL_VALIDATION.md`, and the public-source results are in
`evidence/public-source/RESULTS.md`: 326 checker calls across these three
executables, 28 accepted and 298 rejected, with all harness exits 0. Preserve
stdout, stderr and exit status separately. The original pre-execution contract
and justified amendments remain intact; do not trim malformed input fixtures.
`tests/dump.mind` regenerates all 54 certificates without consulting the checker.

For the K4 legacy API regression, stage the original `finite_nd/tests` sources
with this new kernel as `src/kernel.mind`. For K5, stage the exact sources in
`regression/k5` with this kernel. Both invoke the unchanged version-1 API.
The 33-case prior-review probe under `finite_nd/evidence/independent-review/probe`
can be staged with this kernel as well. The original four-stream arithmetic/
template benchmark is reproduced by its own instructions; its label remains
template checking. Observed receipts are under `evidence/regressions/`.

To repeat the historical LLVM 23 comparison, use its historical compiler and exact sources but
set all four backend variables to the corresponding tools in `/opt/llvm-23/bin`.
Record the actual tool digests, build anew, run all certificates/harnesses and
compare all three output channels. The recorded LLVM 23 version is 23.1.3.
Different executable digests across backend versions are expected here and must
not be described as byte-identical builds. Native-backend diagnostics, if
blocked, do not qualify a new compiler pin.

The recorded 12-mutation campaign used the historical compiler. It has not been
repeated for the extension on the public-source compiler; do not transfer that
qualification across compiler profiles. Apply and run each actual source mutation as described in
`mutations/README.md`. No mutation may be counted as detected because it fails
to compile, crashes or exhausts resources. Tests and source review remain
supporting evidence, not an authorization of NATIVE_VERIFIED.
