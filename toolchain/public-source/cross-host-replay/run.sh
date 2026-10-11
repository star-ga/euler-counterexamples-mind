#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p receipts
awk '/^oom_kill /{print}' /proc/vmstat > receipts/host-oom.before
getconf GNU_LIBC_VERSION > receipts/glibc-version.txt
sha256sum -c SHA256SUMS > receipts/received-checksums.stdout
for name in cli suite independent regression; do
  set +e
  if test "$name" = cli; then
    env -i PATH=/usr/bin:/bin LANG=C LC_ALL=C timeout 15 taskset -c 0 nice -n 19 prlimit --as=268435456 --cpu=10 -- "./$name-check" <inputs/P01_euler_c4_refutation.nd.txt >"receipts/$name-run.stdout" 2>"receipts/$name-run.stderr"
  elif test "$name" = regression; then
    env -i PATH=/usr/bin:/bin LANG=C LC_ALL=C timeout 15 taskset -c 0 nice -n 19 prlimit --as=268435456 --cpu=10 -- "./$name-check" <inputs/arithmetic.txt 3<inputs/refutation.txt 4<inputs/zero-arithmetic.txt 5<inputs/zero-refutation.txt >"receipts/$name-run.stdout" 2>"receipts/$name-run.stderr"
  else
    env -i PATH=/usr/bin:/bin LANG=C LC_ALL=C timeout 15 taskset -c 0 nice -n 19 prlimit --as=268435456 --cpu=10 -- "./$name-check" </dev/null >"receipts/$name-run.stdout" 2>"receipts/$name-run.stderr"
  fi
  rc=$?
  set -e
  printf '%s\n' "$rc" >"receipts/$name-run.exit"
  test "$rc" -eq 0
  test ! -s "receipts/$name-run.stderr"
  cmp "expected/$name.stdout" "receipts/$name-run.stdout"
  printf '%s: exit0; exact stdout match; stderr empty\n' "$name"
done
awk '/^oom_kill /{print}' /proc/vmstat > receipts/host-oom.after
sha256sum ./*-check > receipts/executables.sha256
sha256sum receipts/*-run.stdout receipts/*-run.stderr receipts/*-run.exit > receipts/output-digests.sha256
