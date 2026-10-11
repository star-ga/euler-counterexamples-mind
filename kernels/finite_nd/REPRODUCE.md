# Reproduce candidate certificate acceptance

Author: STARGA Inc.

Use Linux x86-64, the official compiler whose SHA-256 is in
`../../toolchain/compiler.sha256`, and the explicit MLIR CPU configuration from
the original benchmark campaign. Do not replace the pin with another executable of the same version.
This builds a native ELF through MLIR, not the separate experimental native
emitter. No external numerical package is needed by the checker or tests.

Verify the checked-in artifact manifest and compiler digest before execution.
Check at least 8 GiB available RAM, current load and OOM counters. Each build
below uses one allowed CPU, nice19, 1 GiB address space, 50 CPU seconds and a
60-second wall timeout. Runs use 256 MiB, 10 CPU seconds and a 15-second timeout.
Choose an allowed CPU in place of zero if required by your environment. Capture
stdout, stderr and exit status separately for every command; a signal, timeout,
failed build or wrapper failure is never an accepted/refused proof result.

```bash
set -eu
repo=$PWD
package=$repo/kernels/finite_nd
compiler=/path/to/official/pinned/mindc
test "$(sha256sum "$compiler" | cut -d ' ' -f1)" = "$(cat "$repo/toolchain/compiler.sha256")"
(cd "$package" && sha256sum -c SHA256SUMS)
scratch=$(mktemp -d)
export MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt
export MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate
export CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang
mkdir -p "$scratch/cli/src"
cp "$package/Mind.toml" "$scratch/cli/Mind.toml"
cp "$package/src/"*.mind "$scratch/cli/src/"
(cd "$scratch/cli" && timeout 60 taskset -c 0 nice -n 19 \
 prlimit --as=1073741824 --cpu=50 -- "$compiler" build src/main.mind \
 --backend mlir --target cpu --emit binary --optimize debug --no-cache \
 --out "$scratch/kernel-check")
readelf -h "$scratch/kernel-check"
timeout 15 taskset -c 0 nice -n 19 prlimit --as=268435456 --cpu=10 -- \
 "$scratch/kernel-check" < "$package/certificates/P01_euler_c4_refutation.nd.txt"
```

Expected for the exact Euler certificate: exit 0, stdout
`KERNEL_CHECK=PASS` followed by LF, empty stderr. This is a generic checker
label. The certificate hash and reviewed AST tables bind this invocation to
not C4; arbitrary accepted input may establish a different goal. No theorem
name in a filename or receipt confers proof status.

For the MIND finite suite, stage `tests/Mind.toml` at a scratch project
root and copy `tests/main.mind`, `tests/fixtures.mind` and `src/kernel.mind`
into that project's `src/` directory. Build `src/main.mind` with the same
options, then execute without input. The exact
predeclared counts and expected report are in tests/CASE_CONTRACT.md. The
reviewer's separate MIND harness is archived with its own prelist and
receipts in evidence/independent-review.

For each mutation in tests/MUTATION_CONTRACT.md, independently copy the baseline
CLI project, apply its one diff with `patch --batch --fuzz=0 -p1` in `src`, verify
the mutant source hash, and build a fresh ELF. Run its specified positive and
invalid-certificate controls. Success requires normal accepting outputs for
both, and baseline refusal of the invalid proof. Preserve all raw outputs;
never count a build failure, crash or signal as detecting a checker fault.
The unchanged original benchmark is rerun according to its own REPRODUCE.md
and retains its separate template-checking label.

The package's observed dependency hashes identify backend tools, runtime
libraries and ELF bytes. They are not a container image or reproducibly
bootstrapped toolchain. Another platform must recheck its dynamic dependencies
and record new outputs. Project acceptance additionally requires the
owner/designated-verifier action specified in PROOF_POLICY.md; no command here
performs it. Publication of this separate artifact is owner-authorized. See the repository
license and toolchain/README.md for current distribution and bootstrap scope.
