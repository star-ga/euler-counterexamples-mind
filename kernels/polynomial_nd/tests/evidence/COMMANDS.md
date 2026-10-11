# Executed build and run commands

Author: STARGA Inc.

Exact sources were staged as described in `../BUILD.md` in these scratch roots:
`/work/scratch/main`, `/work/scratch/dump`, and
`/work/scratch/resource`; the cache supplement uses
`/work/scratch/cache`. Each command was run from its corresponding
root. The only build substitution was the indicated entry point, with no source
editing or concatenation in the scratch tree.

Each build command used:

```bash
env MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt \
  MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate \
  CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang \
  taskset -c 1 prlimit --as=1073741824 --cpu=1800 -- \
  /usr/bin/time -v -o RECEIPT.time.txt \
  /work/toolchain/mindc \
  build src/main.mind --backend mlir --target cpu --emit binary \
  --optimize debug --no-cache --out OUTPUT > RECEIPT.stdout 2> RECEIPT.stderr
```

| Entry source | OUTPUT | Receipt prefix |
| --- | --- | --- |
| `tests/main.mind` | `/work/scratch/main/check` | `build` |
| `tests/dump.mind` | `/work/scratch/dump/dump` | `dump-build` |
| `tests/resource.mind` | `/work/scratch/resource/resource` | `resource-build` |
| `tests/cache.mind` | `/work/scratch/cache/cache` | `cache-build` |

Runtime commands:

```bash
taskset -c 1 prlimit --as=268435456 --cpu=1800 -- /usr/bin/time -v \
  -o run.time.txt /work/scratch/main/check > run.stdout 2> run.stderr
taskset -c 1 prlimit --as=268435456 --cpu=1800 -- /usr/bin/time -v \
  -o resource-run.time.txt /work/scratch/resource/resource \
  > resource-run.stdout 2> resource-run.stderr
```

Certificate generation used `CASES.tsv` only to route a decimal index to the
MIND generator and give its output a filename. The checker was not involved:

```bash
while IFS=$'\t' read -r index name expected; do
  printf '%s\n' "$index" | taskset -c 1 prlimit --as=268435456 --cpu=60 -- \
    /work/scratch/dump/dump > "certificates/$name.nd.txt"
done < tests/CASES.tsv
```

Individual return statuses were recorded immediately in the `.exit` files or
`generate.exits.tsv`. All raw stdout/stderr files and `/usr/bin/time` receipts
remain in this directory. Paths above use receipt basenames for readability;
actual receipts were redirected into this repository directory by absolute
path during scratch builds.

The final comment-only checker update was copied verbatim into the main,
resource and cache scratch projects. The same commands then rebuilt and reran
those three entries, preserving earlier receipts and using prefix `final-`
for the new build/run receipts. The checker-independent dump was unchanged.
