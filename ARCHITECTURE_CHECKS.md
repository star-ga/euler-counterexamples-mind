# Arch-Mind architecture checks

Author: STARGA Inc.

This repository uses Arch-Mind as an external development instrument. Run the
gate before and after source changes:

```sh
make -f Makefile.arch-mind arch-check ARCH_MIND_HOME=/path/to/approved/arch-mind
```

The installation must match [.arch-mind/toolchain.sha256](.arch-mind/toolchain.sha256).
The adopted version includes the public-function reflection fix described in
[the validation record](.arch-mind/evidence/VALIDATION.md). The older installed
reflector skipped `pub fn` declarations and fails the coverage gate.
The command requires Linux, Bash, GNU Make/coreutils, Git, jq, Python 3 and
the separately installed Arch-Mind CLI. Arch-Mind's source and executable are
not redistributed here. Its commercial availability is separate from the
public MIND proof package. The existing [proof reproduction](REPRODUCE.md)
and [signature verification](signing/README.md) remain independent of this
optional development instrument.

## What the gate checks

The gate copies the current contents of Git-indexed `.mind` paths into a fresh
local snapshot. Untracked, non-ignored MIND source causes rejection; new source
files must be added to the index before checking.
Generated build trees, local state and `.arch-mind/rules.mind` are not source
inputs. It hashes every input and verifies it again after the scan, rejecting
concurrent source or rule changes. Tool components are hash-checked before
and after execution. Nothing uploads source or accesses signing keys.

MIND reflection must return exactly every input path, nonempty declarations,
and the independently counted function declarations for each file. Missing
or partial coverage fails the gate. All reflected declarations, including
benchmark and test files, must contain no detected floating-point or
nondeterministic primitives. The shared finite natural-deduction kernel must
remain present and have no reflected imports; this preserves its current
self-contained implementation boundary.

Arch-Mind then generates a new MIND summary and applies the
[declared determinism rule](.arch-mind/rules.mind) in `enforce` mode. No saved
summary, supplied PASS flag, or previous scan is accepted as a current result.
Each subprocess is limited to 60 seconds and 1 GiB address space and runs at
low priority on one CPU. Set `CPU` to a permitted idle CPU when sharing a host.
Any failure aborts the Make target. Failed runs retain local diagnostic files.

## Honest scope and implementation

The qualified CLI path uses Python reflection and reference implementations of
Arch-Mind's metrics and rules. This integration does **not** claim a native
MIND Arch-Mind execution, a complete MIND parser, compiler validation, or a
proof of program determinism. It does not add Python to the mathematical
checker, its certificates, or its executable mathematical tests.

Reflection uses surface syntax and keyword recognition. The function-count
guard detects some unsupported syntax, but is not a replacement for compiling
the programs. Dependency summaries omit benchmark/test modules by upstream
policy. Import targets in this repository do not resolve into a complete
dependency graph, so acyclicity, modularity and depth scores do not establish
architectural independence. No rule gates those metrics. Evidence-call and
protection-marker density are not mathematical proof coverage, and MCP metrics
have no substantive interpretation in this project.

Arch-Mind acceptance cannot change `FORMAL_PROOF_SUBMITTED`, satisfy an
independent mathematical soundness review, or authorize `NATIVE_VERIFIED`.
[PROOF_POLICY.md](PROOF_POLICY.md) continues to govern those decisions.

## Local state, keys and the existing signed package

`.arch-mind/.gitignore` permits only the declared rules, tool hash list and
reviewed evidence directory. Generated snapshots, summaries, keys, session
ledgers and hook state are local-only. Do not force-add ignored state or key
files. This gate does not create an HMAC session, install global hooks or
modify another session's settings. Public PQC verification keys and signatures
are intentionally public; private keys and seeds are never inputs to this gate.

The Arch-Mind files are additive development material, **outside the existing
PQC-signed payload manifest**. They do not alter or extend that signature's
coverage. Every pre-existing release file remains byte-identical. Verify the
existing source and payload hashes independently:

```sh
sha256sum -c publication/SOURCE_SHA256SUMS
sha256sum -c signing/PAYLOAD_SHA256SUMS
```

The complete signature-and-binding procedure remains in
[signing/README.md](signing/README.md). A later signed release must explicitly
include any newly reviewed architecture material; these files are not silently
represented as part of the old attestation.
