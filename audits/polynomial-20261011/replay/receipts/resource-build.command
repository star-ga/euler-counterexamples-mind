cwd=/work/audit/replay/builds/resource
stdin=/dev/null
command=env -i PATH=/usr/bin:/bin LC_ALL=C LANG=C MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang /usr/bin/time -v -o /work/audit/replay/receipts/resource-build.time taskset -c 6 nice -n 19 timeout 600 prlimit --as=1073741824 --core=0 -- /work/compiler/mindc build src/main.mind --backend mlir --target cpu --emit binary --optimize debug --no-cache --out /work/audit/replay/builds/resource/check 
