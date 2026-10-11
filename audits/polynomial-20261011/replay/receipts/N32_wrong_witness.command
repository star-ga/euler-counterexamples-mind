cwd=/work/audit/replay/builds/cli
stdin=/PUBLIC_REPO/kernels/polynomial_nd/certificates/N32_wrong_witness.nd.txt
command=env -i PATH=/usr/bin:/bin LC_ALL=C LANG=C MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang /usr/bin/time -v -o /work/audit/replay/receipts/N32_wrong_witness.time taskset -c 6 nice -n 19 timeout 600 prlimit --as=268435456 --core=0 -- /work/audit/replay/builds/cli/check 
