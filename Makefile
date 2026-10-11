# Author: STARGA Inc. Build orchestration only; proof/test decisions are MIND.
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
ROOT := $(CURDIR)
BUILD := $(ROOT)/.build
MINDC ?= mindc
MINDC_SHA256 ?= $(shell cat toolchain/compiler.sha256)
CPU ?= $(shell awk '/Cpus_allowed_list:/ {split($$2,a,/[-,]/); print a[1]}' /proc/self/status)
export MLIR_OPT ?= /usr/lib/llvm-20/bin/mlir-opt
export MLIR_TRANSLATE ?= /usr/lib/llvm-20/bin/mlir-translate
export CLANG ?= /usr/lib/llvm-20/bin/clang
export CC ?= /usr/lib/llvm-20/bin/clang
BUILD_LIMIT = timeout 60 taskset -c $(CPU) nice -n 19 prlimit --as=1073741824 --cpu=50 --
RUN_LIMIT = timeout 15 taskset -c $(CPU) nice -n 19 prlimit --as=268435456 --cpu=10 --
COMPILE = $(BUILD_LIMIT) "$(MINDC)" build src/main.mind --backend mlir --target cpu --emit binary --optimize debug --no-cache

.PHONY: check-source check-pin kernel verify test review regression

PQC_MINDC ?= mindc
PQC_MINDC_SHA256 ?= 1550b0d19f76941794521cc8e5ce67c66fbb4d3d940c9ab731d28a63f3d8cd0e
.PHONY: k5-test k5-verify binding-check binding-test signed-verify

k5-test: check-pin check-source
	@mkdir -p "$(BUILD)/k5-suite/src"
	cp benchmarks/euler_sum_of_powers_k5/Mind.toml "$(BUILD)/k5-suite/"
	cp benchmarks/euler_sum_of_powers_k5/src/*.mind kernels/finite_nd/src/kernel.mind "$(BUILD)/k5-suite/src/"
	cd "$(BUILD)/k5-suite" && $(COMPILE) --out "$(BUILD)/k5-suite-check"
	$(RUN_LIMIT) "$(BUILD)/k5-suite-check"

k5-verify: check-pin check-source
	@mkdir -p "$(BUILD)/k5-cli/src"
	cp benchmarks/euler_sum_of_powers_k5/Mind.toml "$(BUILD)/k5-cli/"
	cp benchmarks/euler_sum_of_powers_k5/cli/main.mind benchmarks/euler_sum_of_powers_k5/src/binding.mind kernels/finite_nd/src/kernel.mind "$(BUILD)/k5-cli/src/"
	cd "$(BUILD)/k5-cli" && $(COMPILE) --out "$(BUILD)/k5-check"
	$(RUN_LIMIT) "$(BUILD)/k5-check" < benchmarks/euler_sum_of_powers_k5/certificates/P01_c5_refutation.nd.txt

binding-check: check-pin
	@mkdir -p "$(BUILD)/binding/src"
	cp signing/map-binding/Mind.toml "$(BUILD)/binding/"
	cp signing/map-binding/src/*.mind "$(BUILD)/binding/src/"
	cd "$(BUILD)/binding" && $(COMPILE) --out "$(BUILD)/map-binding-check"

binding-test: check-pin
	@mkdir -p "$(BUILD)/binding-suite/src"
	cp signing/map-binding/Mind.toml "$(BUILD)/binding-suite/"
	cp signing/map-binding/src/bridge.mind "$(BUILD)/binding-suite/src/"
	cp signing/map-binding/tests/suite.mind "$(BUILD)/binding-suite/src/main.mind"
	cd "$(BUILD)/binding-suite" && $(COMPILE) --out "$(BUILD)/binding-suite-check"
	$(RUN_LIMIT) "$(BUILD)/binding-suite-check" 4<signing/map-binding/reference/carrier-twoattrs-unsigned.mic3 5>/dev/null 6>/dev/null 7>/dev/null 8>/dev/null

# Use a fresh checkout with no concurrent writer. Public-key identity must be
# selected independently; these keys alone do not establish organizational trust.
signed-verify: binding-check
	@signer_path="$$(command -v -- "$(PQC_MINDC)")"; test "$$(sha256sum "$$signer_path" | cut -d ' ' -f1)" = "$(PQC_MINDC_SHA256)"
	@set -eu; snapshot=$$(mktemp -d); trap 'rm -rf "$$snapshot"' EXIT; \
	cp signing/package.mic3 "$$snapshot/package.mic3"; \
	cp signing/PAYLOAD_SHA256SUMS "$$snapshot/PAYLOAD_SHA256SUMS"; \
	cp signing/public-keys/*.pub.hex "$$snapshot/"; \
	$(RUN_LIMIT) env -u MIND_EVIDENCE_VERIFY_PUBKEYS "$(PQC_MINDC)" verify "$$snapshot/package.mic3" --json --require-signed --require-strict-fp --require-deterministic \
	  --signer-pubkey "$$(cat "$$snapshot/ml-dsa-87.pub.hex")" \
	  --signer-pubkey "$$(cat "$$snapshot/slh-dsa-shake-256s.pub.hex")"; \
	sha256sum "$$snapshot/PAYLOAD_SHA256SUMS" | cut -d ' ' -f1 > "$$snapshot/expected-digest.txt"; \
	$(RUN_LIMIT) "$(BUILD)/map-binding-check" < "$$snapshot/package.mic3" 3<"$$snapshot/expected-digest.txt"; \
	sha256sum -c "$$snapshot/PAYLOAD_SHA256SUMS"; \
	printf '%s\n' 'SIGNED_PAYLOAD=PASS'

check-source:
	sha256sum -c publication/SOURCE_SHA256SUMS

check-pin:
	@compiler_path="$$(command -v -- "$(MINDC)")"; test "$$(sha256sum "$$compiler_path" | cut -d ' ' -f1)" = "$(MINDC_SHA256)"
	@test "$$(awk '/MemAvailable:/ {print $$2}' /proc/meminfo)" -ge 8388608
	@mkdir -p "$(BUILD)/receipts"
	@printf '%s\n' "$(MINDC_SHA256)" > "$(BUILD)/receipts/compiler.sha256"

kernel: check-pin check-source
	@mkdir -p "$(BUILD)/kernel/src"
	cp kernels/finite_nd/Mind.toml "$(BUILD)/kernel/"
	cp kernels/finite_nd/src/*.mind "$(BUILD)/kernel/src/"
	cd "$(BUILD)/kernel" && $(COMPILE) --out "$(BUILD)/kernel-check"
	sha256sum "$(BUILD)/kernel-check"

verify: kernel
	$(RUN_LIMIT) "$(BUILD)/kernel-check" < kernels/finite_nd/certificates/P01_euler_c4_refutation.nd.txt

test: check-pin check-source
	@mkdir -p "$(BUILD)/suite/src"
	cp kernels/finite_nd/tests/Mind.toml "$(BUILD)/suite/"
	cp kernels/finite_nd/tests/main.mind kernels/finite_nd/tests/fixtures.mind kernels/finite_nd/src/kernel.mind "$(BUILD)/suite/src/"
	cd "$(BUILD)/suite" && $(COMPILE) --out "$(BUILD)/suite-check"
	$(RUN_LIMIT) "$(BUILD)/suite-check"

review: check-pin check-source
	@mkdir -p "$(BUILD)/review/src"
	cp kernels/finite_nd/evidence/independent-review/probe/Mind.toml "$(BUILD)/review/"
	cp kernels/finite_nd/evidence/independent-review/probe/src/main.mind kernels/finite_nd/src/kernel.mind "$(BUILD)/review/src/"
	cd "$(BUILD)/review" && $(COMPILE) --out "$(BUILD)/review-check"
	$(RUN_LIMIT) "$(BUILD)/review-check"

regression: check-pin check-source
	@mkdir -p "$(BUILD)/regression/src"
	cp benchmarks/euler_sum_of_powers_k4/Mind.toml "$(BUILD)/regression/"
	cp benchmarks/euler_sum_of_powers_k4/src/*.mind "$(BUILD)/regression/src/"
	cd "$(BUILD)/regression" && $(COMPILE) --out "$(BUILD)/regression-check"
	$(RUN_LIMIT) "$(BUILD)/regression-check" < benchmarks/euler_sum_of_powers_k4/arithmetic.txt 3< benchmarks/euler_sum_of_powers_k4/refutation.txt 4< benchmarks/euler_sum_of_powers_k4/zero-arithmetic.txt 5< benchmarks/euler_sum_of_powers_k4/zero-refutation.txt
