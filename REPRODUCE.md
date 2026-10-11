# Reproduce the MIND verification

Author: STARGA Inc.

Start with [toolchain availability](toolchain/README.md). The complete checker,
certificates, adversarial fixtures and executable test harnesses are present.
The historical compiler pin is exact; a compatible-looking version string is
not enough. Public compiler bootstrap results, when available, are a separate
profile and must be recorded under their actual digest.

The [public-source bootstrap](toolchain/public-source/README.md) has now been
executed successfully. With that exact rebuilt compiler and the documented
LLVM/MLIR/Clang tools, the following Make targets have also been executed:

```sh
make -j1 verify test review regression \
  MINDC=/absolute/path/to/rebuilt/mindc \
  MINDC_SHA256=c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5
```

If a fresh compiler build has a different digest, record it and qualify its
actual outputs. Do not change the digest merely to bypass a mismatch and then
claim it was the tested compiler. The Make targets use the actual first allowed
CPU by default; override CPU only with a CPU allowed on your host. Mathematical
tests are implemented by the supplied MIND programs, not by Make.

1. Verify `SHA256SUMS` from the repository root and
   `publication/SOURCE_SHA256SUMS` before building.
2. Follow [kernel build/run commands](kernels/finite_nd/REPRODUCE.md) to compile
   the source and check the Euler certificate. Expected: exit 0,
   `KERNEL_CHECK=PASS` plus LF, empty application stderr.
3. Stage and run the [MIND test suite](kernels/finite_nd/tests/BUILD.md).
   Expected: eight static accepts, 1,585 rejects and a restored Euler accept.
4. Stage the separately authored MIND probe under
   `kernels/finite_nd/evidence/independent-review/probe`, build its `src/main.mind`
   with the same pinned compiler, copying the exact kernel into its src directory,
   and run it. Its 33 predeclared decisions are
   supporting finite evidence.
5. Follow the [eight mutation contracts](kernels/finite_nd/tests/MUTATION_CONTRACT.md)
   and apply each source diff separately. Every mutant must build, retain its
   positive control and wrongly accept its designated bad proof while the
   unmodified checker rejects that proof normally. Crashes do not count.
6. Optionally reproduce the earlier
   [four-stream regression benchmark](benchmarks/euler_sum_of_powers_k4/REPRODUCE.md)
   with its unchanged 1,240-case negative contract. It remains template checking.

All mathematical and expected-versus-actual decisions in the executable suites
are MIND. Shell, Git, hashing utilities and build tools are orchestration
dependencies, not proof rules. Capture build/run stdout, stderr, exit values and
executable hashes separately. Resource exhaustion is a failed run, not proof.

For K5, follow [its exact contract and build recipe](benchmarks/euler_sum_of_powers_k5/REPRODUCE.md)
or run `make k5-test k5-verify` with the same explicit compiler settings.
The original kernel is shared without modification. For package authenticity,
follow [the PQC verification recipe](signing/README.md); `make signed-verify`
uses a separately qualified crypto-enabled compiler plus a native MIND
manifest-binding checker. `make binding-test` exercises that binding parser.
All make targets build sequentially by default; do not use unrestricted `-j`.

The archived campaign receipts are sanitized public copies. Generic paths
beginning `/BUILD_` or `/PINNED_TOOLCHAIN` describe the historical execution and
are not commands to execute verbatim. The dedicated reproduction instructions
use caller-supplied paths and fresh scratch directories.
