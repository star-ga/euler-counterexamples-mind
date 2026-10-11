# Reproduce in fresh directories

Required host tools: Linux x86-64, Bash, coreutils, util-linux (`taskset`,
`prlimit`), `/usr/bin/time`, and LLVM/MLIR/Clang 20.1.8 under
`/usr/lib/llvm-20/bin`. Select a CPU permitted by `taskset -pc $$`.

Use the qualified public-source compiler, SHA-256
`c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5`.
Compiler source is public commit
`5724a6ee44cc37fa6e432bf5fc237ef1b70e9624` of
`https://github.com/star-ga/mind.git`.
Its dependency lockfile and complete bootstrap recipe are in the pinned Euler
source's `toolchain/public-source/` directory, at Euler commit
`cacb9492a0c356dd094d08972910fda9232b4472`:

```bash
git clone https://github.com/star-ga/euler-counterexamples-mind.git euler-public
git -C euler-public checkout --detach cacb9492a0c356dd094d08972910fda9232b4472
cat euler-public/toolchain/public-source/README.md
```

Follow that recipe to obtain the pinned compiler and record its hash. Building
the compiler requires the recipe's separate resource policy; the 1 GiB limit
below applies to compiling the MIND harness. The official release executable is
not silently substituted for this qualified source-build profile. A compiler
with another digest requires a separately identified qualification run.

From this exported directory, set the two paths and an allowed CPU. The workspace
must not exist yet; nothing in the exported evidence directory is overwritten:

```bash
compiler_path=/absolute/path/to/qualified/mindc
fresh_workspace=/absolute/path/to/new-adversarial-replay
allowed_cpu=7
sha256sum -c SHA256SUMS
bash reproduce.sh "$compiler_path" "$fresh_workspace" "$allowed_cpu"
cat "$fresh_workspace/final/evidence/build.exit"
cat "$fresh_workspace/final/evidence/run.exit"
tail -n 3 "$fresh_workspace/final/evidence/run.stdout"
cat "$fresh_workspace/initial/evidence/build.exit"
cat "$fresh_workspace/initial/evidence/run.exit"
tail -n 3 "$fresh_workspace/initial/evidence/run.stdout"
```

Both builds/runs should exit 0. Final stdout ends `999999`, `82`, `0` on separate
lines; initial stdout ends `999999`, `64`, `0`. Earlier lines are the MIND
case/actual/expected triplets. Stderr should be empty on successful builds/runs;
build stdout contains normal compiler progress lines. The script retains exact
new source/compiler/binary hashes, ELF identification, stdout, stderr, exit codes,
and time/RSS observations under each project's `evidence/` directory.

Builds use one allowed CPU, nice 19, 1 GiB address space, 180 CPU seconds, and a
240-second timeout. Runs use one CPU, nice 19, 256 MiB address space, 120 CPU
seconds, and a 150-second timeout. Programs are generated through `--backend mlir
--target cpu`, not the blocked direct-native backend. Script success is an
engineering regression result; proof status remains `FORMAL_PROOF_SUBMITTED`.

The two original failed builds are retained as evidence rather than reproduced
by default. Their duplicate-entry-source cause and subsequent repair are in
`AMENDMENTS.md`; neither was counted as a successful refusal test.

The exported reproduction script itself was exercised before package freeze
against the same freshly rebuilt pinned compiler on CPU 7. Its final and initial
build/run exits were all 0, with final markers `(999999,82,0)` and
`(999999,64,0)`. Those additional transport-validation receipts are retained under
`evidence/export-reproduction-final/` and `evidence/export-reproduction-initial/`.
The generated executables and build caches were excluded from this package.
