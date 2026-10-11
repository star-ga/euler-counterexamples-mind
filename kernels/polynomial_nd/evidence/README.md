# Execution evidence layout

Author: STARGA Inc.

`llvm20/` and `llvm23/` retain historical final-source CLI build receipts and all
54 certificate stdout/stderr/exit triples. LLVM 23 harness receipts are under
`llvm23/{main,resource,cache}`; historical LLVM 20 harness receipts are under
`../tests/evidence/final-*`. The separately executed public-source compiler
initial qualification is under `public-source/`; its scope is the three
harnesses and 326 checker calls. The later [public-download replay](public-replay/RESULTS.md)
repeated those harnesses and covered all 54 CLI certificates using the same
compiler. Its stage streams/exits and case table are separate under `public-replay/`.

`mutations/M01` through `M12` retain actual historical mutated-source builds,
positive controls and distinguishing invalid-certificate runs. Source diffs in
`../mutations/` are byte-identical. Earlier scratch-layout failures and the
campaign before comment clarification remain identified separately; neither is
silently counted as final-source fault detection.

`regressions/` contains historical K4/K5 API and prior-review probe receipts and
the unchanged arithmetic/template benchmark. Sources and public prerequisites
are described in `../REPRODUCE.md`.

Absolute local execution paths have been replaced with generic `/work/`
placeholders. These are sanitized copies of historical observations, not newly
executed receipts. Compiler/executable digests, expected results and measured
values were retained. Original/current file hashes and all transformations are
recorded in `../PUBLICATION.md` and `../PUBLICATION_FILES.tsv`.

Historical `.sha256` files describe the originally observed artifacts, including
executables that are not redistributed. Use the package's regenerated
`SHA256SUMS` to verify the current export bytes. Internal governance execution
receipts and full development native-backend diagnostics are excluded. A scoped
native compatibility summary and unchanged scalar-control source remain under
`native/`; that control is not a polynomial proof qualification.

Malformed certificate endings, unified-diff context whitespace and test
expectations were preserved exactly. Successful engineering gates do not grant
formal acceptance or publication approval.
