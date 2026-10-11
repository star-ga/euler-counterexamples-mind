#!/usr/bin/env bash
set -u
cd /work/audit/independent-signature-review || exit 2
for case_name in public-base public-old-substitution public-bridge-change; do
  env -i PATH=/usr/bin:/bin LANG=C LC_ALL=C \
    MINDC=/work/compiler/math/mindc \
    PQC_MINDC=/work/compiler/pqc/mindc CPU=7 \
    timeout 180 taskset -c 7 nice -n 19 /usr/bin/time -v -o "evidence/$case_name.time" \
    bash "$case_name/signing/polynomial/verify.sh" \
    > "evidence/$case_name.stdout" 2> "evidence/$case_name.stderr"
  case_rc=$?
  printf '%s\n' "$case_rc" > "evidence/$case_name.exit"
done
(cd public-base && sha256sum -c signing/PAYLOAD_SHA256SUMS) \
  > evidence/historical.stdout 2> evidence/historical.stderr
printf '%s\n' "$?" > evidence/historical.exit
