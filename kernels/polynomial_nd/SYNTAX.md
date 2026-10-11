# NDv2 symbolic polynomial certificate profile

Author: STARGA Inc.

This candidate extends the [NDv1 encoding](../finite_nd/SYNTAX.md) with one
inference rule. The mathematical domain is the unbounded integers Z. This
profile does not change the original NDv1 checker or signed public release.

The wire format retains magic 74123, canonical unsigned decimal fields followed
by LF, topologically ordered term/formula tables, declared goal, proof lines and
exact EOF. NDv2 uses version **2**. Node tags, syntax, parsing bounds, structural
substitution, the nine original rules and assumption handling are unchanged.
The entry points deliberately distinguish versions:

```mind
finite_nd_check(p, n, work, cap)       // strict version 1; cap >= 65536
finite_nd_poly_check(p, n, work, cap)  // strict version 2; cap >= 4194304
```

The caller owns valid readable input and aligned writable workspace of the
stated extent. The regions must not overlap. The API checks numeric ranges,
alignment, cap and overlap, but cannot establish allocation ownership. NDv2's
CLI allocates both regions and accepts a single certificate from stdin.

## Rule 10: POLY_ID

The proof record is `(10, result, 0, 0, 0)`. `result` must be a **closed** formula
of precisely the shape `Forall^k(Eq(L,R))`, with `1 <= k <= 4`. No implication,
positivity or conjunction body is admitted. Extra premise or auxiliary fields
are refused. A certificate provides only the original term ASTs, never a trusted
normal form, arithmetic assertion, theorem identifier or PASS flag.

The checker independently normalizes every declared term at the first POLY_ID
instruction, then compares the canonical polynomials of the body's two actual
term references. A successful rule has no assumption dependencies. Its creation
context is the active assumption mask, so a line produced inside a scope cannot
be reused after that scope closes. Final-goal matching and discharge checks are
the same as NDv1. Universal elimination can subsequently instantiate the proved
identity at a closed term using the original structural substitution rule.

For `forall x. forall y. ...`, de Bruijn index 0 denotes y and index 1 denotes
x. Variables range over negative integers as well as zero and positive integers.
There is no enumeration or numerical sampling of this domain.

## Canonical polynomial representation

A polynomial is an ascending list of distinct monomial keys and strictly
positive exact coefficients. Zero is the empty list. The key encodes
`e0 + 33*e1 + 33^2*e2 + 33^3*e3`, where each exponent is in 0..32. The monomial
denotes `X0^e0 * X1^e1 * X2^e2 * X3^e3`. Addition inserts/merges keys;
multiplication independently checks all four exponent sums and convolves the
coefficient lists. Zero coefficients are omitted, and equal keys are merged by
checked exact addition. Equality checks list lengths, every key and every limb.

Each coefficient has 12 little-endian base-1000 limbs, with no modular or
floating-point arithmetic. An overflowing addition or multiplication refuses.
All terms are normalized topologically, even unused terms; an unsupported unused
term therefore also refuses once POLY_ID is invoked. A completed cache is reused
for subsequent POLY_ID lines in the same certificate only.

| Limit | Bound |
| --- | --- |
| Input, term/formula/proof counts, AST depth | Unchanged NDv1 limits |
| Quantifiers enclosing POLY_ID equality | 1..4 |
| Variable indices in normalized terms | 0..3 |
| Exponent per variable per monomial | 0..32 |
| Nonzero monomials per term | 128 |
| Coefficient value | 0..10^36-1 |
| Polynomial work units per certificate | 2,000,000 |
| NDv2 caller workspace | 4,194,304 bytes |

A work unit is charged for each normalized term; insertion invocation; existing
key inspected by insertion; record shifted; product pair; and equality-record
comparison. Coefficient operations have constant bounded 12/24-limb loops. The
original independent structural-comparison budget remains 200,000. Every budget
check fails closed before the charged operation. Work is not reset between rules.

Workspace layout: original ND records occupy the first 65,536 bytes. Each of the
256 polynomial cache entries uses `8 + 128*104 = 13,320` bytes (count, then key
and 12 limbs per monomial). The cache ends at offset 3,475,456. A 96-byte temporary
coefficient begins there. This is inside the 4 MiB extent; unused trailing bytes
are reserved. Header offsets 80, 96 and 104 hold version, polynomial work budget
and cache-complete marker. Only the original 65,536 bytes are cleared at entry;
each cache count is initialized before use, and only initialized records are read.

The bounds restrict which proofs this partial checker accepts, not the integers
quantified in a successfully checked theorem. Unsupported syntax and exhaustion
are ordinary rejection. CLI exit 0 means candidate certificate acceptance,
exit 1 rejection, exit 2 an execution/I/O failure. None grants project acceptance.
