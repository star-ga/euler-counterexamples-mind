# Reproduction from the public Euler commit

Author: STARGA Inc.
Date: 2026-10-11
Result: **PASS_WITH_NOTES — manual reproduction on the same host.**

The public source at commit
`5cca55f16a52f7dd468a7f19733ef2c2c54a497f` was downloaded anonymously from
[GitHub's commit archive](https://codeload.github.com/star-ga/euler-counterexamples-mind/tar.gz/5cca55f16a52f7dd468a7f19733ef2c2c54a497f).
The request returned HTTP 200 without credentials. Archive SHA-256:
`45ca59316d10ff5762abb4efc5f35331e829bc7a78dda15f6e9682b2da4ec964`.
All 2,499 downloaded files remained unchanged after execution; the original
base and polynomial manifests passed. The tested package manifest digest was
`d43ba5f3585dbb958a8b80af677aea125c9e8ca3eeab8b772ad0f0ae2f7b3edc`.
That digest identifies the tested commit, before these later documentation
and receipt additions. The current package manifest covers the current files.

The existing public-source compiler was hash-verified, not rebuilt or installed:
`c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5`.
Kernel SHA-256 remained
`7eed71f7cb06715744471edf80da5b6b1f3cdadb2ba345e3605814d2951fa3e2`.
The profile was MIND 0.10.2, Linux x86-64, LLVM/MLIR/Clang 20.1.8, explicit
MLIR CPU backend. No compiler pin, checker source or certificate changed.

| Executable | Calls | Accepted / refused | Build exit | Run outcomes |
| --- | ---: | --- | ---: | --- |
| Main harness | 321 | 25 / 296 | 0 | Harness exit 0 |
| Resource harness | 2 | 1 / 1 | 0 | Harness exit 0 |
| Cache harness | 3 | 2 / 1 | 0 | Harness exit 0 |
| Standalone CLI | 54 | 16 / 38 | 0 | 16 exits 0; 38 ordinary exits 1 |

The harness total is 326 calls: 28 accepts and 298 refusals. The CLI's 54
invocations are reported separately; their inputs overlap the harness fixtures.
The first two CLI receipts were reused when extending the run to the remaining
52 cases. No failed build, crash, signal or timeout counted as a refusal.
All stdout, stderr and exit values matched their expectations. Harness stdout
and executable hashes matched the previously published public-source profile.

| Executable | SHA-256 |
| --- | --- |
| Main | `33ede8b8c6480d6587294f3c2b3382d41e133e6bb42eccd326b90b0f2f8c5f81` |
| Resource | `ea7abfa65a127b72abca744a2b497535aae5914632d79267c5a2d04161af9085` |
| Cache | `02b99f06802a5088bab64e6f72ba081bc4cde76ac431ddd6e36f3bafd7d79d1d` |
| CLI | `c7a63b0503af8c338821c07ea9433f68c0545fa12699fbbda7706797d97a8ce8` |

The [reproduction instructions](../../REPRODUCE.md) give the staging, build and
run commands. For the full CLI corpus, use the same invocation for each exact
certificate named by [the prelisted cases](../../tests/CASES.tsv): declared
acceptance 1 requires exit 0 and `KERNEL_CHECK=PASS` followed by LF; declaration
0 requires exit 1 and `KERNEL_CHECK=FAIL` followed by LF. Stderr must be empty.
[Per-case outcomes](receipts/cli-cases-observed.tsv) record every exit and both
stream hashes. The 183 stage stdout/stderr/exit files cover four builds and
57 runs. Their [export map](EXPORT_FILES.tsv) preserves original and exported
digests. Only four build-stdout local paths became `/work/replay/builds`;
application outputs and exit bytes are unchanged. Raw machine paths are omitted.
Verify current exported bytes with the package's `SHA256SUMS`.

Each stage used CPU 6, nice 19, a 600-second wall deadline, 1 GiB build address
space or 256 MiB run address space. Peak build RSS was 148,328 KiB; maximum CLI
RSS was 8,288 KiB. No OOM counter increment or timeout occurred.

This independent-agent replay establishes a bounded, same-host engineering
result. It does not establish a new compiler bootstrap, cross-host replication,
direct-native compatibility or a new mutation/LLVM 23 campaign. GitHub CI is
not configured. The soundness argument remains prose; independent formal
acceptance is open and status stays `FORMAL_PROOF_SUBMITTED`. Existing PQC
signatures do not cover this extension or these later receipts.
