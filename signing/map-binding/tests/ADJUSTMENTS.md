# Build-layout correction

Author: STARGA Inc.

The first checker build failed before executing tests: project compilation
included both `src/main.mind` and `src/tests.mind`, producing duplicate `main`
symbols. Raw first-attempt receipts are `receipts/build-checker.*`.

Moved the unchanged test source to `tests/suite.mind` and staged an isolated
suite project containing exactly that source as `src/main.mind` and the unchanged
checker as `src/bridge.mind`. No case, expected result or checker logic changed.
The initial manifest is preserved as `tests/PREEXECUTION_INITIAL.sha256`;
the active manifest records the new path. A build failure does not count as a
test outcome or a mutation result.

After execution, the owner requested the term `MIND` in new documentation.
The final contract removes one descriptive adjective from its final paragraph;
all test cases and expectations are unchanged. Exact executed contract and
manifest are preserved under `tests/history/`. Executable sources and binaries
are unchanged. The final content manifest records the editorial document hash.
