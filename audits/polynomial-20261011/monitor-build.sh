#!/usr/bin/env bash
set -euo pipefail
out=/work/audit/receipts
unit=euler-independent-compiler-20261011.service
printf 'epoch\tstate\tmemory_current\tmemory_peak\tavailable_kB\tload1\thost_oom_kill\n' > "$out/compiler-monitor.tsv"
while true; do
  state=$(systemctl --user show "$unit" -p ActiveState --value)
  group=$(systemctl --user show "$unit" -p ControlGroup --value)
  current=unavailable; peak=unavailable
  if [ -n "$group" ] && [ -r "/sys/fs/cgroup$group/memory.current" ]; then
    current=$(cat "/sys/fs/cgroup$group/memory.current")
    peak=$(cat "/sys/fs/cgroup$group/memory.peak")
    cat "/sys/fs/cgroup$group/memory.events" > "$out/compiler-memory.events.latest"
  fi
  available=$(awk '/MemAvailable:/{print $2}' /proc/meminfo)
  load=$(awk '{print $1}' /proc/loadavg)
  oom=$(awk '/oom_kill/{print $2}' /proc/vmstat)
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$(date +%s)" "$state" "$current" "$peak" "$available" "$load" "$oom" >> "$out/compiler-monitor.tsv"
  sub=$(systemctl --user show "$unit" -p SubState --value)
  if [ "$sub" = exited ] || [ "$state" = failed ] || [ "$state" = inactive ]; then break; fi
  if [ "$available" -lt 8388608 ]; then
    printf 'Own compiler stopped: host MemAvailable fell below 8 GiB.\n' > "$out/compiler-host-guard.txt"
    systemctl --user stop "$unit"
    break
  fi
  sleep 2
done
systemctl --user show "$unit" -p Result -p ExecMainStatus -p ExecMainCode -p MemoryPeak -p MemoryMax -p MemorySwapMax -p CPUUsageNSec -p CPUQuotaPerSecUSec -p AllowedCPUs -p Nice -p ExecMainStartTimestamp -p ExecMainExitTimestamp > "$out/compiler-service.txt"
awk '/oom_kill/{print $2}' /proc/vmstat > "$out/host-oom-after.txt"
