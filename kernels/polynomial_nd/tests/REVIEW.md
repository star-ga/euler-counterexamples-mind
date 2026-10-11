# Independent implementation review

Author: STARGA Inc.

Verdict: **PASS_WITH_NOTES**, scoped to source review and candidate engineering
evidence. No critical, high, or medium soundness defect was found. The one low
documentation defect was corrected and rechecked in the final addendum below. This is not an
owner/designated-verifier decision and does not authorize `NATIVE_VERIFIED`.

## Independence and exact scope

The reviewer authored the adversarial tests and certificate generator, but did
not implement or edit the checker, its syntax, soundness argument, or foundations.
The original case plan and its amendments were fixed before the reviewer first
inspected the new checker source. This review is independent of the checker
implementation author; it is **not** independent of the test author. The later
cache supplement is explicitly source-informed and separately predeclared.

Read in full: `src/kernel.mind`, `SOUNDNESS.md`, `SYNTAX.md`, and `FOUNDATIONS.md`.
Compared the complete kernel diff against the unchanged NDv1 source. Read the
legacy syntax, contribution and proof policies, and the parameter-capability
audit before writing tests. The reviewed identities are:

| Artifact | SHA-256 |
| --- | --- |
| `src/kernel.mind` | `6b7c0afefd279c1b127ad074a8893dd3a11a6ca30e22a3118cb29631c0621542` |
| `SOUNDNESS.md` | `d14308c81524bf98913f7e45f9984ef9325963a1da1b5f53113396beb33cb9e0` |
| `SYNTAX.md` | `5dfc8f755ab1efead2dcc274fec39d88e213a7c74fa97b58c6ab730190439866` |
| `FOUNDATIONS.md` | `69ccf5425f9f5d65483e1df6e9b68c67e21b81d23721a012a753fb6351fcc7d7` |

Source references below use line numbers in that exact kernel digest.

## Concrete finding

**LOW — stale workspace precondition comment (`src/kernel.mind:529`).** The
comment above the shared versioned entry states that the caller owns only
`[work,work+65536)`. The version-2 branch selects 4,194,304 bytes at line 535 and
the polynomial routines legitimately write past 65,536. A caller following the
comment and incorrectly supplying a large `cap` for a 65,536-byte allocation
could cause memory corruption. The checked numeric contract and SYNTAX.md are
correct; this is a contradictory source comment, not a certificate exploit
against a caller satisfying the documented allocation precondition. Replace the
comment with the version-selected extent (65,536 for v1; 4,194,304 for v2).
The reviewer did not change the implementation. A comment-only repair should
retain this review's original hash and attach the final source identity.

## Arithmetic and normalization correspondence

- `nd_add` (49) validates digits and carry, has maximum intermediate 1999, and
  rejects the final carry. In-place accumulation in `poly_insert` (148) is safe:
  it overwrites only the already-consumed limb of the first operand. The second
  operand comes from an earlier, distinct term or the separate temporary.
- `nd_multiply` (63) uses the separate 24-limb buffer at offset 63856, validates
  every digit and carry, and has maximum scalar intermediate 999999. Prior rows
  end before the next row's final carry slot. Every upper result limb is checked
  before copying the twelve lower limbs. It computes exact nonnegative integer
  coefficients and never uses a wrapped i64 product as theorem evidence.
- `poly_insert` (135) drops zero coefficients, merges equal keys by checked
  addition, and refuses a 129th distinct key before a shift/write. Descending
  record movement preserves every unread record. Positive coefficients cannot
  cancel, so successful entries remain sorted, distinct, and nonzero.
- `poly_product` (187) visits every pair, computes the key through four checked
  exponent digits, multiplies the actual source coefficients, then inserts the
  result. `poly_key_product` (164) checks each sum before packing. The bound
  `33^4-1 = 1,185,920` makes the representation injective. Without that bound,
  x^33 could alias the next variable; the adversarial N37 targets that exact risk.
- `poly_normalize` (207) processes the validated DAG in declaration order and
  sets the completed-cache marker only after all terms succeed. Child IDs are
  strictly earlier (293), hence neither child cache can alias its destination.
  Sources of coefficient records are initialized numerals, a unit coefficient,
  or prior successful arithmetic. Although internal equality/positivity helpers
  do not revalidate every invariant, certificates cannot provide cache records.
- The normalization/evaluation induction in SOUNDNESS.md:55 applies to every
  integer environment. Nonnegative coefficients do not restrict variable values
  to nonnegative integers. Equality checks every key and all twelve limbs (241),
  which suffices for equality in every environment; no numeric samples or
  theorem-specific constants appear in the checker.

## Binding, scope, and fail-closed boundaries

`poly_rule` (255) requires exactly one through four universal wrappers and an
equality body. Parser-derived binder demand must be covered by those binders;
goal and proof-line closedness are independently enforced at 556 and 438.
Vacuous quantification is sound, and every real variable occurrence maps to an
integer environment component. This rule has no open eigenvariable context or
general universal introduction whose side condition could be silently omitted.

Rule 10 checks zero premises/auxiliary fields (443), starts with dependency mask
zero (441), and records the active creation context (523). `nd_premise` (415)
checks both dependency and creation masks. Discharge still requires the exact
top assumption occurrence and an actual Bottom result (503). Consequently a
true polynomial fact generated inside a popped scope cannot later be reused
under this deliberately conservative calculus.

The substitution path remains structural. Closed witnesses are enforced at 480;
the de Bruijn test at 373 replaces the chosen binder, lowers greater indices,
preserves smaller ones, and increments depth under nested quantifiers (406).
The polynomial normal form is never substituted for exact structural checking.
Both ground rules now explicitly check closed operands (458, 463), preserving
the defense against unevaluated symbolic buffers being interpreted as zero.

The entry point checks cap, positive pointers, length, alignment, signed address
addition, and nonoverlap before writing workspace (533). Parsing is canonical
and bounded. Unsupported tags, forward references, depth/count excesses, parser
errors and arithmetic failures propagate refusal. Exact EOF, empty scope, zero
dependencies and a structural match to the declared goal are required at
559–566. The strict v1 wrapper passes version 1 and cannot normalize via rule 10.

## Memory and work accounting

Each cache entry uses 13,320 bytes; all 256 occupy
`[65536,3475456)`. The twelve-limb temporary occupies `[3475456,3475552)`, below
4,194,304. Counts are initialized before use, and a count becomes visible only
after its record is written. The original 65,536-byte clear also resets the
cache marker and all proof/parser state. Earlier calls cannot supply a completed
cache to a new certificate. The numeric API checks cannot prove actual memory
ownership; that remains an explicit caller precondition.

All potentially expanding loops consume the same polynomial work counter at
their stated operations. Term/cache counts and coefficient loops are separately
bounded. A failed insertion may leave partial scratch writes, but every such
failure aborts the whole check; no partial result becomes accepted. The cache
supplement checks that a second valid POLY_ID uses three further comparison
units for P01, with no reset or renormalization, and that a false second identity
still rejects after cache completion.

## Evidence and remaining obligations

The reviewer executed the 321-call public-API suite against the reviewed source:
25 accepts and 296 ordinary rejects, exit 0, empty stderr. All 54 generated files
were produced by a checker-independent MIND builder. The two-call resource probe
accepted the 128-monomial control with 1,990,459 units left and rejected the work
exhaustion case with zero left. The three-call cache supplement produced:

```text
ONE_RULE_RESULT=1
ONE_RULE_BUDGET=1999952
TWO_RULE_RESULT=1
TWO_RULE_BUDGET=1999949
FALSE_SECOND_RULE_RESULT=0
CACHE_TESTS=PASS
FORMAL_ACCEPTANCE=BLOCKED
```

Receipts are in `evidence/`; pre-execution hashes identify the corresponding
plans and sources. The intentional extra LF in N24 must be preserved even if a
generic whitespace checker flags it. No failed run was discarded or relabeled.

Source mutation execution and cross-toolchain checks belong to the integrator's
separate receipts and are not independently asserted by this reviewer. Neither
this finite suite nor this prose review proves the source, compiler, OS, or
hardware correct. The normalization metatheorem is not machine-checked. Owner
approval of the soundness rules and complete evidence remains outstanding, so
`FORMAL_PROOF_SUBMITTED` remains the strongest permitted theorem classification.

## Final source addendum

The integrator corrected the workspace/header comments. The reviewer inspected
the exact diff in `evidence/final-source-comment.diff.txt`: it changes comments
only, including the v1/v2 workspace extent, and resolves the low finding. The
final checker hash is
`7eed71f7cb06715744471edf80da5b6b1f3cdadb2ba345e3605814d2951fa3e2`.
Earlier line references intentionally remain attached to the original digest.

The reviewer rebuilt and reran all three harnesses from that exact final source
using the pinned compiler and LLVM 20. All builds and executions exited 0 with
empty stderr. The 321 main-suite outcomes, two resource outcomes, and three cache
outcomes are unchanged, and all three stdout streams compare byte-for-byte with
their originals. All three ELF hashes are also unchanged by the comment repair.
See `evidence/FINAL_VALIDATION.md` and `evidence/final-identities.sha256`.
No implementation defect remains open from this scoped review. The formal
acceptance and independence limitations above continue to apply.
