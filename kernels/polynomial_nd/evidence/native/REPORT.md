# Direct native-backend compatibility boundary

Author: STARGA Inc.

Status: **BLOCKED for this polynomial checker**. This is a scoped summary of
historical compatibility diagnostics, not a newly qualified compiler profile.
The successful public-source qualification uses the explicit MLIR CPU backend.

Exact diagnostic excerpts from separate direct-native attempts were:

```text
error[backend-native]: `main` calls `__mind_alloc`, which has no definition in the closure (closure.unresolved_edge)
error[backend-native]: `src/main.mind` is not in the frozen native profile (out-of-profile construct: binop.mod).
error[backend-native]: `main` calls `printI64`, which has no definition in the closure (closure.unresolved_edge)
```

The historical pinned compiler `a1444e44...ffa` refused allocation closure;
separate compatibility attempts encountered the modulo and printing blockers.
Each attempt exited 3 before producing a checker or harness executable. No
polynomial native-backend run, cross-backend equivalence or native proof
acceptance follows from these diagnostics. Modulo is required for exact
base-1000 arithmetic and exponent/workspace checks; deleting it would change
the checked implementation.

Full development-driver reports, correspondence, source-discovery details and
raw traces are outside this export. Their omission is deliberate and means
this summary is not a standalone replay of those development diagnostics.
The byte-identical `control/src/main.mind` and `control/Mind.toml` are retained
only as source for the scalar `return 42` control. Its historical success does
not establish polynomial support or public reproducibility of that driver.

A future direct-native profile needs publicly reproducible compiler provenance,
successful builds of the exact checker and all harnesses, and complete matching
stdout/stderr/exit results without weakened admission guards. Until then, use
[the qualified public-source MLIR profile](../public-source/RESULTS.md).
