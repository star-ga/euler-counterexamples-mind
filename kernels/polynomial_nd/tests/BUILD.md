# Reproducing the polynomial adversarial suite

Author: STARGA Inc.

Stage a fresh project with this directory's `Mind.toml` at its root and these
exact sources under `src/`:

| Repository source | Staged source |
| --- | --- |
| `tests/main.mind` | `src/main.mind` |
| `tests/fixtures.mind` | `src/fixtures.mind` |
| `../finite_nd/tests/fixtures.mind` | `src/legacy_fixtures.mind` |
| `src/kernel.mind` | `src/kernel.mind` |

Use the pinned compiler and CPU backend recorded in `evidence/identities.sha256`:

```text
mindc build src/main.mind --backend mlir --target cpu --emit binary --optimize debug --no-cache --out check
```

The tested environment binds `MLIR_OPT`, `MLIR_TRANSLATE`, `CLANG`, and `CC` to
LLVM 20 tools. Build limits: one CPU, 1 GiB address space, 1800 CPU seconds.
Runtime limits: one CPU, 256 MiB address space, 1800 CPU seconds. Verify native
ELF before execution. Raw stdout, stderr, exit, timing and hashes are retained.
The suite's decisions and fixture construction are all MIND.

To regenerate certificate files, stage `dump.mind` as `src/main.mind` with
`fixtures.mind` and the same project manifest. This generator does not import
the checker. Its stdin is a fixture index followed by LF; its stdout is exactly
the encoded certificate, including deliberately malformed endings. `CASES.tsv`
maps indices to names and expected results. A shell may route those input and
output bytes, without generating or checking mathematics itself:

```text
printf '0\n' | ./dump > P01_binomial.nd.txt
```

Stage `resource.mind` as the entry point for the separate supporting diagnostic
described in `FIXTURE_CLARIFICATIONS.md`. That probe imports `kernel.mind` and
`fixtures.mind` only.

Stage `cache.mind` with those same two imports for the separately predeclared,
source-informed `CACHE_CONTRACT.md` supplement. It adds three checker calls.

The full suite expects 54 new fixtures (16 accepts, 38 rejects), all 57 unchanged
legacy fixtures (8 accepts, 49 rejects), 17 legacy-version refusals, six API
refusals, 93 proper-prefix refusals, 93 byte-mutation refusals, and one restored
binomial acceptance. This is 321 public checker invocations: 25 accepts and
296 rejects. The printed `EXPECTED_ACCEPTS=24` excludes the final separately
labeled restoration acceptance. The resource diagnostic adds two invocations.
The cache diagnostic adds three: two accepts and one reject. Across these three
harnesses the final source receives 326 calls: 28 accepts and 298 rejects.

These are candidate engineering checks. Theorem status remains
`FORMAL_PROOF_SUBMITTED`; formal acceptance remains blocked by PROOF_POLICY.md.
