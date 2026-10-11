# K5 independent-machine replay

Author: STARGA Inc.

Host B is a separate x86-64 Linux machine using glibc 2.34. Host A compiled
the programs with historical compiler `a1444e44…`; their exact binaries and
the public P01 certificate were transferred to a fresh temporary directory.
No private key, private repository or host credential is part of the transfer
or this public evidence. This is binary replay, not a second compiler build.

| Program | SHA-256 | Exit | stdout SHA-256 | stderr |
| --- | --- | ---: | --- | --- |
| K5 suite | `6ea17d9ac45a95c159bb161a7f0c4f12b9fab479f332528ffb7634da2453fd8e` | 0 | `e9593d49cd0c917c66a4c129a11be50ecdd01a44f5acd10591bfcb81f0bb7910` | empty |
| K5 CLI | `3feb32223ac15ec3c488214515d12ceaac67ea535a53df1bffa19a4c7138db02` | 0 | `dc53a580214b54318fcf0435e1cc58dad5b0f03827081afb99140b7f622309ab` | empty |

Both complete stdout files, empty stderr files and normal exit values match
Host A's original runs. The suite contains the frozen 42 static paired tests
and 2,090 systematic corruptions, followed by restored-certificate acceptance.
The CLI prints C5-bound acceptance and FORMAL_ACCEPTANCE=BLOCKED. These are
reproducible candidate-checker results, not authorized kernel validation.

Commands in the fresh replay directory were:

```sh
cpu=$(awk '/Cpus_allowed_list:/ {split($2,a,/[-,]/); print a[1]}' /proc/self/status)
timeout 15 taskset -c "$cpu" nice -n 19 prlimit --as=268435456 --cpu=10 -- ./suite
timeout 15 taskset -c "$cpu" nice -n 19 prlimit --as=268435456 --cpu=10 -- ./cli < P01_c5_refutation.nd.txt
```

Each process used one CPU with a 256 MiB address-space limit and low priority.
Before/after OOM counters are retained. `inputs.sha256` also records the
separate metadata-binding diagnostic transferred in the same session; that
diagnostic is not the final release signature. No universal platform or
compiler bit-identity claim follows from this measured two-host replay.
