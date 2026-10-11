# Independent-machine replay of public-source-built artifacts

Author: STARGA Inc.

On 2026-10-11, the four unchanged executables built on Host A by the qualified public-source compiler were transferred with their exact certificates and a checksummed input list to Host B. Host A uses glibc 2.43; Host B uses glibc 2.34. Both are Linux x86-64. No compiler or project source was rebuilt on Host B.

Each program ran under one allowed CPU, nice19, a 256 MiB address-space limit, ten CPU seconds and a fifteen-second wall timeout. The child environment was empty except PATH and the C locale. Preflight found sufficient memory and space for the approximately 100 KiB compressed payload. No GPU, installation, shared repository edit or other-job change occurred.

| Program | Exit | Stdout SHA-256 | Comparison with Host A |
|---|---|---|---|
| CLI with exact Euler certificate | 0 | a7ffcdcdd9d4d48fe402253a1ebdde41ad1dba6190d9af165908bfa965f79e85 | Identical stdout, stderr and exit |
| Main finite ND suite | 0 | 264a0a98fffda94bd324081a60b595b5de64782d9806c8d98f003df25cad7739 | Identical stdout, stderr and exit |
| Independently authored 33-case harness | 0 | 4cf04ffd30735328827932ec80992f169a6747ae236746d9d975e6ca954a0cb3 | Identical stdout, stderr and exit |
| Original four-stream benchmark | 0 | 89de310a6ca3fe4514d67b9b379f7d2491126d42294101211184cff10cbace79 | Identical stdout, stderr and exit |

All stderr streams are zero bytes, SHA-256 `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855`. Each exit receipt is the two bytes `0` and LF, SHA-256 `9a271f2a916b0b6ee6cecb2426f0b3206ef074578be55d9bc94f6f3fe3ab86aa`. Received executable hashes matched the frozen payload and the public-source profile's four artifact hashes. After retrieval, stdout/stderr/exit files were compared directly with Host A's fresh qualification receipts and matched byte-for-byte.

The host aggregate oom_kill counter stayed unchanged at 14. This is a host-wide observation, not a separately isolated per-job cgroup measurement. Peak RSS was not measured on Host B. The original instrumentation invoked an unavailable /usr/bin/time, causing env to exit127 before any candidate ran; the retained correction removed only that recorder. Timeout, CPU affinity, priority, address-space and CPU-time limits remained unchanged. The completed four-call replay used a fresh directory.

This establishes observed cross-machine replay agreement of the same four compiled artifacts. It is not an independent compiler implementation, remote source-build qualification, arbitrary-platform guarantee, or automatic proof-policy promotion. Machine identities and access routes are intentionally excluded from this public receipt.

The archived `run.sh` records the executed transfer-payload command. Its original ELF/input payload is intentionally omitted, so it is not a standalone reproduction script. Build the four programs and provide the input streams using the repository-root reproduction instructions.
