#!/usr/bin/env bash
# Author: STARGA Inc. Provenance orchestration; no mathematical proof decisions.
set -euo pipefail
umask 077
repo=$(cd "$(dirname "$0")/../.." && pwd -P)
: "${MINDC:?Set MINDC to the qualified mathematical compiler}"
: "${PQC_MINDC:?Set PQC_MINDC to the qualified signing-enabled compiler}"
MINDC=$(realpath "$MINDC")
PQC_MINDC=$(realpath "$PQC_MINDC")
MINDC_SHA256=${MINDC_SHA256:-c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5}
PQC_MINDC_SHA256=${PQC_MINDC_SHA256:-1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e}
CPU=${CPU:-$(awk '/Cpus_allowed_list:/{split($2,a,/[-,]/); print a[1]}' /proc/self/status)}
test "$(sha256sum "$MINDC" | cut -d ' ' -f1)" = "$MINDC_SHA256"
test "$(sha256sum "$PQC_MINDC" | cut -d ' ' -f1)" = "$PQC_MINDC_SHA256"
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT
cp "$repo/signing/polynomial/package.mic3" "$scratch/package.mic3"
cp "$repo/signing/polynomial/PAYLOAD_SHA256SUMS" "$scratch/PAYLOAD_SHA256SUMS"
cp "$repo/signing/public-keys/"*.pub.hex "$scratch/"
test "$(xxd -r -p "$scratch/ml-dsa-87.pub.hex" | sha256sum | cut -d ' ' -f1)" = 0c7f47a456f77dbacbbdd4a5a03328b20543859461dc9c00f49289467a594eb0
test "$(xxd -r -p "$scratch/slh-dsa-shake-256s.pub.hex" | sha256sum | cut -d ' ' -f1)" = ac85e7ecbd748a1ab57e67e44ca9b60e490ba7a7786e9ef4c707f790531c1e84
# This reviewed wrapper and these bootstrap pins must be obtained through a
# trusted channel. Never execute an unauthenticated repository Makefile/checker.
mkdir -p "$scratch/build/src"
cp "$repo/signing/map-binding/Mind.toml" "$scratch/build/Mind.toml"
cp "$repo/signing/map-binding/src/bridge.mind" "$scratch/build/src/bridge.mind"
cp "$repo/signing/map-binding/src/main.mind" "$scratch/build/src/main.mind"
(cd "$scratch/build" && sha256sum -c <<'PINS'
4c08d6ac178f5aa0514e3494226b950244553b00a143772dd68e17277ac8f600  Mind.toml
a6fa375827cca00fbfe0d79e06c2a0c09b37efad4e9fe59c5aca0450cbcbfe0a  src/bridge.mind
fcc41d9b61b6b2db8a6b3fa8cb17b8829c9cef7b13b35639edeba9cddfe80325  src/main.mind
PINS
)
sha256sum -c <<'PINS'
c9e187870c70663e6a15129e68c064d382be6d991de91f9670daecf3c8016d4c  /usr/lib/llvm-20/bin/mlir-opt
f03e82b5b3c9fffbf1eb00f8a9e461878dbecf52d0061d41184865ab4ceb58c3  /usr/lib/llvm-20/bin/mlir-translate
7c19dc665abb898a09fe5976c44f7691d7c137534dd5fcf6a76dfaab334c90c8  /usr/lib/llvm-20/bin/clang
PINS
(cd "$scratch/build" && env -i PATH=/usr/bin:/bin LC_ALL=C LANG=C \
  MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate \
  CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang \
  timeout 60 taskset -c "$CPU" nice -n 19 prlimit --as=1073741824 --cpu=50 --core=0 -- \
  "$MINDC" build src/main.mind --backend mlir --target cpu --emit binary --optimize debug --no-cache --out "$scratch/build/map-binding-check")
limit=(timeout 30 taskset -c "$CPU" nice -n 19 prlimit --as=268435456 --cpu=20 --core=0 --)
"${limit[@]}" env -u MIND_EVIDENCE_VERIFY_PUBKEYS "$PQC_MINDC" verify "$scratch/package.mic3" --json --require-signed --require-strict-fp --require-deterministic \
  --signer-pubkey "$(cat "$scratch/ml-dsa-87.pub.hex")" \
  --signer-pubkey "$(cat "$scratch/slh-dsa-shake-256s.pub.hex")"
sha256sum "$scratch/PAYLOAD_SHA256SUMS" | cut -d ' ' -f1 > "$scratch/expected-digest.txt"
"${limit[@]}" "$scratch/build/map-binding-check" < "$scratch/package.mic3" 3< "$scratch/expected-digest.txt"
# A valid historical K4/K5 signature is not a signature of this extension.
# Require this release's scope, unique canonical paths, and complete inventory.
awk '
BEGIN {
  required["kernels/polynomial_nd/src/kernel.mind"]=1
  required["kernels/polynomial_nd/certificates/P01_binomial.nd.txt"]=1
  required["kernels/polynomial_nd/certificates/P02_scaled_k4.nd.txt"]=1
  required["kernels/polynomial_nd/tests/CASES.tsv"]=1
  required["audits/polynomial-20261011/REPORT.md"]=1
  required["audits/polynomial-20261011/SOURCE_REVIEW.md"]=1
  required["audits/polynomial-20261011/replay/receipts/CORPUS_RESULTS.tsv"]=1
  required["signing/polynomial/verify.sh"]=1
  required["signing/polynomial/tests/tamper.mind"]=1
  required["signing/polynomial/PAYLOAD_FILES.txt"]=1
}
{
  if (length($0)<67 || substr($0,1,64) !~ /^[0-9a-f]+$/ || substr($0,65,2)!="  ") { bad=1; next }
  path=substr($0,67)
  if (path !~ /^[A-Za-z0-9_.\/-]+$/ || path ~ /^\// || path ~ /\/\// || path ~ /\/$/ || path ~ /(^|\/)\.\.?($|\/)/ || seen[path]++) { bad=1; next }
  delete required[path]
  print path
}
END { for (path in required) bad=1; if (bad) exit 1 }
' "$scratch/PAYLOAD_SHA256SUMS" > "$scratch/observed-paths.txt"
(cd "$repo" && sha256sum -c "$scratch/PAYLOAD_SHA256SUMS")
cmp "$scratch/observed-paths.txt" "$repo/signing/polynomial/PAYLOAD_FILES.txt"
printf 'POLYNOMIAL_SIGNED_PAYLOAD=PASS\n'
