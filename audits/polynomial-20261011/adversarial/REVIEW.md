# Independent polynomial checker boundary review

Verdict: PASS_WITH_NOTES for the exercised implementation contract. No concrete
checker defect was reproduced in this review. This is finite engineering evidence,
not an owner/designated-verifier soundness approval. `FORMAL_PROOF_SUBMITTED`
remains unchanged; the direct-native backend remains `BLOCKED` and was not used.

## Exact subject and independence

- Read-only repository: `/work/audit/euler-pinned`.
- Pinned commit: `cacb9492a0c356dd094d08972910fda9232b4472`.
- Reviewed/copied kernel: `kernels/polynomial_nd/src/kernel.mind`, SHA-256
  `7eed71f7cb06715744471edf80da5b6b1f3cdadb2ba345e3605814d2951fa3e2`.
- Final independent MIND harness: `src/main.mind`, SHA-256
  `07a311845f4ef2f14d2cc28c63e5de58745ac093169caffb55db60cb37c3437a`.
- Initial 64-call harness archived at `archive/main.initial.mind`, SHA-256
  `9aa0eeba566329df17e74fbb4ab64ec7ba238245e4ac01aef51a02ee6ce79e9e`.
- Initial compiler path:
  `/work/compiler/initial/mindc`.
- Fresh compiler path supplied by the parent after its source rebuild:
  `/work/compiler/fresh/mindc`.
- Both compiler files have SHA-256
  `c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5`.
- Fresh final ELF SHA-256:
  `2310b9b6e41eb9f0de7043e3afd7a77bf82aace98b06869521adb02524c70a1d`.

The repository's syntax, soundness, foundations, proof policy, complete kernel
source, build instructions and build command transport were read. Existing
favorable review/results files and existing fixture implementation were not used
to determine outcomes. The builder, case selection, and checks here are new MIND
code. Follow-up IDs41–43 were suggested by a separate independent source reviewer;
that communication and the source-informed nature of all probes are disclosed.

The freshly built compiler is byte-identical to the initial compiler. Rebuilding
with it provides source-build reproducibility evidence supplied by the parent,
not an independently implemented compiler or independent compiler semantics.
The same pinned checker implementation is tested twice; the independent element
is the authored cases and their mathematical expectations, not a second checker.

## Precommitment and execution

`CASES.tsv` declared the first 64 checker invocations and expected outcomes before
execution. `PREEXECUTION.sha256` and its timestamp freeze the original source.
`FOLLOWUP.tsv` declared another18 invocations before execution;
`PREEXECUTION_FOLLOWUP.sha256` freezes the expanded source. No expectation was
changed in response to a result. `AMENDMENTS.md` records a source-layout repair;
`PREEXECUTION_FINAL.sha256` hashes every final executable input, both manifests,
and the amendment record before the successful fresh-compiler replay. Its final
`sha256sum -c` succeeded for all eight files.

The final suite has82 invocations:19 expected acceptances and63 expected refusals.
It creates all certificate bytes in MIND, calls the public API, compares actual
acceptance to the MIND expectation, checks byte-for-byte input immutability for
all80 calls with owned readable inputs, and asserts zero mismatches. Two numeric
address-overflow guard probes intentionally use out-of-range pointer values;
these are API guard checks, not malformed-certificate ownership tests. A signal
or crash in any case would be execution failure and never counted as detection.

| Run / receipt prefix | Build exit | Run exit | Calls | Mismatches |
| --- | --- | --- | --- | --- |
| initial | 0 | 0 |64|0|
| followup | 1 | not run |0|not applicable|
| fresh | 1 | not run |0|not applicable|
| followup-fixed |0|0|82|0|
| fresh-fixed |0|0|82|0|

The two link failures were caused by keeping the old harness as a second `.mind`
file under `src/`; project mode compiled both entry sources and the linker refused
duplicate function definitions. The archive moved outside `src/`, and the old
build directory moved under `archive/`. No kernel or executable harness source
changed for this repair. These are harness packaging failures and contribute
zero successful checker detections. Their exact stderr and exit receipts remain.

For successful runs, build stdout contains the normal Finished/Artifact status
lines; build stderr and runtime stderr are empty. Runtime stdout prints a triplet per case `(id, actual, expected)` as three decimal
lines. Fresh stdout ends exactly:

```text
999999
82
0
```

Full unedited stdout is `evidence/fresh-fixed-run.stdout`; every triplet has
actual=expected. The initial and fixed follow-up raw logs also remain in evidence/.
Receipt suffixes `.exit`, `.stdout`, `.stderr`, `.time`, `-identities.sha256` and
`-elf.txt` identify the exact outputs and timings. `backend-identities.sha256`
records LLVM20 tool hashes. No compiler/build success is counted as a proof result.

Exact successful final command, from this review directory:

```bash
bash run.sh /work/compiler/fresh/mindc fresh-fixed
```

`run.sh` preserves the complete command and redirections. Its effective build is:

```bash
env MLIR_OPT=/usr/lib/llvm-20/bin/mlir-opt \
  MLIR_TRANSLATE=/usr/lib/llvm-20/bin/mlir-translate \
  CLANG=/usr/lib/llvm-20/bin/clang CC=/usr/lib/llvm-20/bin/clang \
  taskset -c 7 nice -n 19 prlimit --as=1073741824 --cpu=180 -- \
  timeout 240 /usr/bin/time -v -o evidence/fresh-fixed-build.time \
  /work/compiler/fresh/mindc \
  build src/main.mind --backend mlir --target cpu --emit binary \
  --optimize debug --no-cache --out check-fresh-fixed \
  > evidence/fresh-fixed-build.stdout 2> evidence/fresh-fixed-build.stderr
```

The effective runtime is:

```bash
taskset -c 7 nice -n 19 prlimit --as=268435456 --cpu=120 -- \
  timeout 150 /usr/bin/time -v -o evidence/fresh-fixed-run.time \
  ./check-fresh-fixed \
  > evidence/fresh-fixed-run.stdout 2> evidence/fresh-fixed-run.stderr
```

Fresh build elapsed1.28s, maximum RSS108480KiB; fresh runtime elapsed below the
time utility's0.01s display granularity, maximum RSS6204KiB. No timing claim beyond
those recorded observations is made. CPU7 was allowed by affinity0–11. The output
is x86-64 dynamically linked ELF produced through the MLIR CPU/LLVM20 backend.
There was no network/system security testing, source-tree mutation, signing,
commit, benchmark claim, or status promotion.

## What the probes establish, within their finite scope

All line references below are to the pinned polynomial kernel.

1. **Exact coefficient arithmetic and comparison.** Lines51–97 bound each limb
   operation and refuse carries/upper product limbs beyond12 base1000 digits.
   IDs3–7 distinguish representable10^36−1 from symbolic addition/multiplication
   overflow, unused overflow, and ground overflow. IDs17 and19 cover a real carry
   and differing coefficients. IDs401–412 claim x=(1+1000^j)x for every j=0..11;
   x=1 disproves each. All twelve false certificates refused, exercising the
   comparison loop at99–105 and its use at252. Overflow refusal is not a theorem
   of bounded mathematical integers; quantified variables still range over Z.

2. **Packed exponent integrity.** Lines166–176 check all four base33 digits before
   encoding a product. IDs10–13,44–46 accept degree32, reject each possible carry
   from degree33 into the next variable, reject overflow beyond the fourth digit,
   and accept a product with all four exponents32. The false equalities
   x_j^33=x_(j+1) fail at x_j=0,x_(j+1)=1; x_3^33=0 fails at x_3=1.

3. **Normalization, legitimate aliasing and capacity.** Lines137–164 merge equal
   keys before rejecting a genuinely new129th key;189–207 convolve only actual
   nonzero records. IDs8–9 allow identical child references. IDs28–29 bracket
   128/129 monomials. ID43 confirms P128+P128=2P128 keeps128 keys. ID41 accepts
   x^32*(0*x^32)=0 because the zero intermediate has no monomial pairs; ID42
   refuses0*(x^32*x)=0 because the independently declared x^33 exceeds the
   admission profile. ID42 is a true identity refused by this partial checker,
   not a false mathematical statement and not a soundness defect.

4. **Workspace initialization and reuse.** Entry clears the first65536 bytes at543,
   including cache-valid offset104. Normalization resets every count at219 and
   sets cache-valid only at241 after the complete pass. IDs201–205 use a workspace
   deliberately filled with maximal signed words, a dense128-monomial certificate,
   a false replacement with a forged preexisting valid flag, a maximum coefficient
   certificate, a failed partial overflow, then a zero-polynomial certificate.
   True/false outcomes were preserved across all transitions. ID30 additionally
   refuses a false second POLY_ID in the same certificate after a true first rule.

5. **Binder closure and structural substitution.** Binder-demand metadata is built
   at291–309,325–355; every proof result must be closed at440. FORALL_ELIM checks
   the witness is closed at482 and traverses the claimed instance at484 using
   the rules at368–412. IDs15,20–23,40 distinguish valid nested instantiation,
   wrong captured binder, open witness, a mathematically true but nonmatching
   claimed instance, and open GROUND_EQ. The false nested result
   forall y.7+y=y+y fails at y=0. The true y+y=y+y in ID23 is nevertheless not
   the structural instance specified by the supplied universal premise.

6. **Proof contexts.** Premise use requires both dependency and creation-context
   masks to remain active at417–426; occurrence bits are monotonic at449–456;
   final scope/dependency checks are at566–569. IDs24–27 reject use after close,
   reject reactivation via a new assumption occurrence, reject an unclosed final
   proof, and accept consumption while the original scope is active. These are
   derivation-contract checks even when the reused polynomial theorem itself is
   universally true; they do not independently exhibit a false theorem.

7. **Encoding, graph structure and declared goal.** Lines19–43 parse canonical
   bounded decimal/LF;295 and338 enforce topological references;445 rejects
   reserved proof fields;548 enforces version;565 requires exact EOF;569 compares
   the final result to the goal. IDs31–39 and101–111 refuse a mismatched goal,
   future references, reserved fields, unsupported version/rule, leading zero,
   CR/space/sign/NUL/high-byte/empty input field, an overlarge field, missing LF,
   and trailing LF/digit. No comprehensive parser fuzzer was run.

8. **Caller memory versus certificate validity.** Numeric guards at539–542 enforce
   extent, alignment, signed address arithmetic, and overlap before workspace
   writes. IDs301–306 test partial overlap in either order, misalignment, one-byte
   short cap, and address addition overflow. IDs307–308 accept exactly adjacent
   half-open regions in a single owned allocation. Invalid allocation ownership,
   OS mapping permissions, external mutation and races remain API preconditions;
   they were not mislabeled as certificate bugs. No fabricated pointer was used
   beyond the explicitly expected-to-refuse overflow guards.

## Coverage limits and disposition

This review did not prove the compiler, parser, arithmetic implementation, or
normalization metatheorem. It did not test every AST, all budget-exhaustion paths,
all256/512 node limits, hostile concurrency, invalid OS mappings, or other
architectures/backends. It did not independently verify public signatures,
publication, source-build provenance, or the owner's formal acceptance conditions.
The parent review owns full corpus replay and compiler source-rebuild receipts.

The source supplies a coherent mechanism for each exercised refusal, and accepted
neighboring cases prevent a trivial always-reject implementation from satisfying
the test suite. Finite passing tests cannot establish universal soundness. There
is no reproduced source defect to attach a severity/remediation to. Preserve
`FORMAL_PROOF_SUBMITTED`, keep direct-native `BLOCKED`, and retain the existing
requirement for substantive owner/designated-verifier acceptance.
