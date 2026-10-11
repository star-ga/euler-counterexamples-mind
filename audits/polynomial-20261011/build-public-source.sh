#!/bin/sh
set -eu
profile=/work/audit
exec bwrap --die-with-parent --new-session --unshare-net --unshare-ipc --unshare-pid --unshare-uts \
 --ro-bind /usr /usr --ro-bind /lib /lib --ro-bind /lib64 /lib64 --symlink usr/bin /bin \
 --dir /etc --ro-bind /etc/ld.so.cache /etc/ld.so.cache --ro-bind /etc/alternatives /etc/alternatives \
 --proc /proc --dev /dev --tmpfs /tmp \
 --ro-bind /work/rust-toolchain /toolchain \
 --ro-bind "$profile/public-source" /source --bind "$profile/compiler-target" /target \
 --bind "$profile/cargo-home" /cargo \
 --ro-bind /work/cargo-registry/cache /cargo/registry/cache \
 --ro-bind /work/cargo-registry/src /cargo/registry/src \
 --ro-bind /work/cargo-registry/index /cargo/registry/index \
 --clearenv --setenv PATH /toolchain/bin:/usr/bin:/bin --setenv HOME /tmp \
 --setenv LANG C --setenv LC_ALL C --setenv CARGO_HOME /cargo \
 --setenv CARGO_TARGET_DIR /target --setenv CARGO_BUILD_JOBS 1 \
 --chdir /source /usr/bin/time -v /toolchain/bin/cargo build --release --bin mindc \
 --features 'std-surface mlir-build cross-module-imports' --locked --offline
