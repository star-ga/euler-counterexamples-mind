# Factual report correction

The first report incorrectly said:

> For successful runs, build stdout, build stderr, and runtime stderr are empty.

The current `REVIEW.md` corrects that sentence to:

> For successful runs, build stdout contains the normal Finished/Artifact status
> lines; build stderr and runtime stderr are empty.

The original report is retained as `archive/REVIEW.original.md`, with only the
declared operational path normalization. For example,
`evidence/fresh-fixed-build.stdout` actually contains:

```text
   Finished cpu [binary] check-fresh-fixed
   Artifact: 67696 bytes
```

The correction changes no case, source, mathematical expectation, observed
result, or status. `EXPORT_MAP.tsv` distinguishes the factual prose correction
from path normalization and records both original and exported hashes.

`evidence/review.sha256` records the original, pre-normalization report digest;
it is historical evidence, not a checksum of the corrected exported report.
