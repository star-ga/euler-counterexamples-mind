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
