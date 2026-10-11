#!/usr/bin/env bash
set -euo pipefail
umask 077
repo=/PUBLIC_REPO
scratch=/work/audit/signature-controls
compiler=/work/pqc/mindc
binding=/work/audit/binding-build/map-binding-check
mkdir -p "$scratch"
cp "$repo/signing/polynomial/package.mic3" "$scratch/package.mic3"
cp "$repo/signing/polynomial/PAYLOAD_SHA256SUMS" "$scratch/PAYLOAD_SHA256SUMS"
sha256sum "$scratch/PAYLOAD_SHA256SUMS" | cut -d ' ' -f1 > "$scratch/digest.txt"
printf '%064d\n' 0 > "$scratch/wrong-digest.txt"
good_mldsa=$(cat "$repo/signing/public-keys/ml-dsa-87.pub.hex")
good_slh=$(cat "$repo/signing/public-keys/slh-dsa-shake-256s.pub.hex")
printf -v wrong_mldsa '%05184d' 0
printf -v wrong_slh '%0128d' 0
limit=(timeout 30 taskset -c 6 nice -n 19 prlimit --as=268435456 --cpu=20 --core=0 --)
run() {
  local label=$1 expected=$2; shift 2
  set +e
  env -i PATH=/usr/bin:/bin LC_ALL=C LANG=C "${limit[@]}" "$@" > "$scratch/$label.stdout" 2> "$scratch/$label.stderr"
  local rc=$?
  set -e
  printf '%s\n' "$rc" > "$scratch/$label.exit"
  printf '%s\t%s\t%s\n' "$label" "$expected" "$rc" >> "$scratch/RESULTS.tsv"
  test "$rc" = "$expected"
}
printf 'case\texpected_exit\tobserved_exit\n' > "$scratch/RESULTS.tsv"
run generator 0 /work/audit/tamper-build/check < "$scratch/package.mic3" 3< "$scratch/digest.txt" 4> "$scratch/corrupt-mldsa.mic3" 5> "$scratch/corrupt-slh.mic3" 6> "$scratch/corrupt-digest.mic3"
sha256sum "$scratch/"*.mic3 "$scratch/"*digest.txt > "$scratch/CONTROL_INPUTS.sha256"
verify_args=(--json --require-signed --require-strict-fp --require-deterministic)
run crypto-baseline 0 "$compiler" verify "$scratch/package.mic3" "${verify_args[@]}" --signer-pubkey "$good_mldsa" --signer-pubkey "$good_slh"
for label in corrupt-mldsa corrupt-slh corrupt-digest; do
  run "$label" 1 "$compiler" verify "$scratch/$label.mic3" "${verify_args[@]}" --signer-pubkey "$good_mldsa" --signer-pubkey "$good_slh"
done
run wrong-mldsa-pin 1 "$compiler" verify "$scratch/package.mic3" "${verify_args[@]}" --signer-pubkey "$wrong_mldsa" --signer-pubkey "$good_slh"
run wrong-slh-pin 1 "$compiler" verify "$scratch/package.mic3" "${verify_args[@]}" --signer-pubkey "$good_mldsa" --signer-pubkey "$wrong_slh"
run binding-correct 0 "$binding" < "$scratch/package.mic3" 3< "$scratch/digest.txt"
run binding-wrong 1 "$binding" < "$scratch/package.mic3" 3< "$scratch/wrong-digest.txt"
printf 'MAP_DIGEST_BINDING=PASS\n' > "$scratch/expected-pass.txt"
printf 'MAP_DIGEST_BINDING=FAIL\n' > "$scratch/expected-fail.txt"
cmp "$scratch/binding-correct.stdout" "$scratch/expected-pass.txt"
cmp "$scratch/binding-wrong.stdout" "$scratch/expected-fail.txt"
test ! -s "$scratch/binding-correct.stderr"
test ! -s "$scratch/binding-wrong.stderr"
sha256sum -c "$scratch/CONTROL_INPUTS.sha256" > "$scratch/inputs-after.stdout"
printf 'SIGNATURE_CONTROLS=PASS\n'
