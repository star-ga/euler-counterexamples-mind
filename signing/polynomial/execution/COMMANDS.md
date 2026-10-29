# Commands and resources

Author: STARGA Inc.

Public verification is the command in `../README.md`. The committed wrapper
stages its hash-pinned MIND metadata checker and enforces the recorded compiler,
backend and key identities. Run from an immutable checkout without another writer.

Owner emission, with both seed variables already configured securely outside
the checkout (never put their values in argv):

```sh
digest=$(sha256sum signing/polynomial/PAYLOAD_SHA256SUMS | cut -d ' ' -f1)
timeout 90 taskset -c 6 nice -n 19 prlimit --as=1073741824 --cpu=80 --core=0 -- \
  "$PQC_MINDC" signing/polynomial/carrier.mind \
  --emit-evidence signing/polynomial/package.mic3 \
  --evidence-attr "org.starga.package_manifest_sha256=$digest" \
  --evidence-attr org.starga.attestation_scope=package-provenance
```

Repeat to a separate scratch output and compare with `cmp`. Public reviewers
do not need the seed variables and cannot be expected to reproduce emission.
Anyone with the public dependencies and keys can reproduce verification.

To regenerate the three corruption controls, stage `signing/map-binding/Mind.toml`
and `src/bridge.mind` into a fresh project, with `../tests/tamper.mind` as its
`src/main.mind`. Build using the mathematical compiler and explicit MLIR/LLVM20
CPU configuration. Run the resulting MIND ELF with the exact artifact on stdin,
64 lowercase manifest-hash digits plus LF on fd3, and fresh output files on
fd4 (ML-DSA corruption), fd5 (SLH-DSA corruption), fd6 (digest corruption).
The generator must exit zero. Verify each output with both pinned public keys
and require normal exit 1. `run-signature-controls.sh` preserves the actual
transport sequence with documented `/work/...` path substitutions; adapt those
paths to the staged tools and receipts. Mathematical/provenance binding decisions
are in MIND; cryptography is the official compiler facility.

Signing used one CPU, nice19, 1 GiB address space, 80 CPU seconds and 90 wall
seconds. Crypto and MIND controls used one CPU, nice19, 256 MiB, 20 CPU seconds
and 30 wall seconds. Wrapper bootstrap compilation used 1 GiB, 50 CPU seconds
and 60 wall seconds. Failures of resource limits do not count as normal refusal.
CPU 6 is a measured local choice; select a permitted idle CPU on another host.
