# Finite natural-deduction candidate: certificate and API

Author: STARGA Inc.

This is a candidate generic checker. A successful `finite_nd_check` call or
`KERNEL_CHECK=PASS` CLI result does **not** establish project formal acceptance.
The requirements in [PROOF_POLICY.md](../../PROOF_POLICY.md) still apply.
There is no theorem identifier or Euler witness in the checker. The caller must
separately bind a benchmark certificate's declared goal to its intended statement.

## Encoding

Every field is one canonical unsigned decimal integer followed by one byte LF
(`0x0a`). Every value is in `0..999999`. Zero is exactly `0\n`; other values have
no leading zero. Signs, spaces, empty lines, CRLF, non-ASCII bytes, missing final
LF and trailing bytes are rejected. Tuples below denote consecutive lines, not
literal punctuation or space-separated fields.

The complete stream is:

1. Magic `74123`, version `1`.
2. Term count `T`, where `1 <= T <= 256`.
3. Exactly `T` term records `(tag, a, b)`.
4. Formula count `F`, where `1 <= F <= 512`.
5. Exactly `F` formula records `(tag, a, b)`.
6. Goal formula reference in `1..F`.
7. Proof length `P`, where `1 <= P <= 256`.
8. Exactly `P` proof records `(rule, result, p1, p2, aux)`.
9. End of input immediately after the final field's LF.

Term, formula and proof references are **1-based**, in declaration order.
De Bruijn variable indices are **0-based**. Term children refer strictly to
earlier terms. Formula children refer strictly to earlier formulas; atomic
formula terms may refer to any declared term. Proof premises refer strictly to
earlier proof lines. Unsupported tags and references are refused.

## Terms and formulas

| Term tag | Meaning | `a` | `b` |
| --- | --- | --- | --- |
| 1 | Unsigned numeral | Magnitude `0..999999` | Must be `0` |
| 2 | De Bruijn variable | Index `0..31` | Must be `0` |
| 3 | Addition | Earlier term reference | Earlier term reference |
| 4 | Multiplication | Earlier term reference | Earlier term reference |

Numeral sign flags are not implemented: `b=1` is rejected. Variables and
quantifiers range over **all mathematical integers**, including negatives. The
available ground witnesses form a nonnegative fragment; this is a completeness
restriction, not a change to the domain of quantification. No exponentiation
constructor is provided; powers are products represented explicitly in the AST.

| Formula tag | Meaning | `a` | `b` |
| --- | --- | --- | --- |
| 1 | Term is strictly greater than zero | Term reference | Must be `0` |
| 2 | Equality | Left term reference | Right term reference |
| 3 | Bottom | Must be `0` | Must be `0` |
| 4 | Conjunction | Earlier formula reference | Earlier formula reference |
| 5 | Implication | Earlier antecedent reference | Earlier consequent reference |
| 6 | Universal quantification over integers | Earlier body formula reference | Must be `0` |

Negation is the abbreviation `Imp(A, Bottom)`, not an additional constructor.
Intermediate formula definitions can have free de Bruijn indices: they may be
bodies subsequently enclosed in universal quantifiers. The goal and **every**
proof result, including an assumption, must be closed.

The checker computes each node's required number of enclosing binders in
topological order: numeral `0`, variable `index+1`, binary constructor the
maximum of its children, and universal formula `max(body_requirement-1, 0)`.
Atoms inherit their term requirements. Closed means requirement zero.

## Proof instructions

`result` always references the entire claimed conclusion formula. All unused
fields must be zero. Every premise must still be available in the current
assumption scope before applying its rule.

| Rule | Name | Premises and auxiliary fields | Checked conclusion |
| --- | --- | --- | --- |
| 1 | ASSUME | `p1=p2=aux=0` | Introduce `result` as a new scoped assumption |
| 2 | GROUND_POS | `p1=p2=aux=0` | Closed positive atom whose exact term value is greater than zero |
| 3 | GROUND_EQ | `p1=p2=aux=0` | Closed equality whose exact left and right values agree |
| 4 | AND_INTRO | `p1` proves A, `p2` proves B; `aux=0` | `And(A,B)` |
| 5 | AND_LEFT | `p1` proves `And(A,B)`; `p2=aux=0` | A |
| 6 | AND_RIGHT | `p1` proves `And(A,B)`; `p2=aux=0` | B |
| 7 | IMP_ELIM | `p1` proves `Imp(A,B)`, `p2` proves A; `aux=0` | B |
| 8 | FORALL_ELIM | `p1` proves `Forall(A)`; `p2=0`; `aux` is a closed term reference | Capture-safe instantiation of A at that term |
| 9 | NEG_INTRO | `p1` is the current top assumption occurrence; `p2` proves Bottom; `aux=0` | `Imp(formula_at_p1, Bottom)` after discharging precisely that occurrence |

Logical formula matches are structural, including all term constructors and
variable indices. They do not equate two differently structured terms because
their evaluated values happen to agree. There is no pointer/index equality
shortcut. Ground equality is a distinct inference rule that compares computed
integer values.

Universal instantiation traverses the quantified body with binder depth `k`,
initially zero. A variable with index `k` is replaced by the entire closed
auxiliary term; indices greater than `k` decrease by one; indices below `k`
are unchanged. Entering another universal quantifier increments `k`. Closed
replacement terms need no variable lifting. Source and claimed result formulas
are compared during that traversal; the checker does not trust a supplied
substitution receipt.

Each assumption occurrence receives a fresh, monotonically increasing bit
number. There are at most **30 occurrences per certificate**, even if earlier
ones have been discharged. Bits are never reused at the same stack depth.
Each proof line records both its actual dependency mask and its creation-context
mask. **Both** masks must be subsets of the currently active mask whenever that
line is used as a premise. This deliberately conservative rule also prevents
reuse of an assumption-independent line created inside a closed scope.

Ground rules have no assumption dependencies. ASSUME depends on its own bit.
Unary elimination rules inherit dependencies; binary rules take their union.
NEG_INTRO first checks premise availability, the actual Bottom conclusion and
the exact top-of-stack assumption occurrence. Its result has the contradiction's
dependencies with that assumption bit removed; its creation context is recorded
after the pop. Vacuous discharge is allowed. A final result is accepted only if
the assumption stack and active mask are empty, the final line's dependencies
are zero, and its formula structurally equals the declared closed goal.

## Exact arithmetic and work limits

Ground values are 12 little-endian base-1000 limbs, representing integers in
`0..1000^12-1` (`0..10^36-1`). All ground terms are computed once in declaration
order. An overflowing ground term rejects the certificate even if that term is
not subsequently used. Non-ground terms are not numerically evaluated.

Addition checks every input digit and carry; its largest intermediate is
`999+999+1=1999`. Multiplication uses a 24-limb temporary and schoolbook rows;
the largest inner intermediate is `999*999+999+999=999999`. Digits and carries
are checked, and all upper 12 result limbs must be zero. These calculations
remain within signed i64 without wraparound. The bounds depend on ordinary
in-range compiler integer arithmetic and correct load/store behavior.

| Resource | Bound |
| --- | --- |
| Input size | `1..65536` bytes |
| Workspace used | Exactly 65536 bytes cleared; records occupy first 64048 bytes |
| Term nodes | 256 |
| Formula nodes | 512 |
| Proof instructions | 256 |
| Term AST depth | 32, counting a leaf as depth 1 |
| Formula AST depth | 32, counting an atom as depth 1 |
| Variable index | `0..31` |
| Assumption occurrences | 30 total, never recycled |
| Structural comparison calls | 200000 total per certificate |
| Structural recursion counter | `0..64`, inclusive; a greater counter refuses |

Parsing, binder-demand analysis and arithmetic are bounded topological loops;
they never recursively unfold DAGs. All recursive term/formula equality and
substitution calls consume the same per-certificate comparison budget before
inspection. Exhaustion is refusal, not a partial-success result. Ordinary
process CPU/time/address-space limits should additionally bound the executable.

## API and CLI

```mind
pub fn finite_nd_check(p: i64, n: i64, work: i64, cap: i64) -> i64
```

The caller must own readable input `[p,p+n)` and writable workspace
`[work,work+65536)`, with neither region aliasing executable code or other
externally mutable state. The function checks positive pointers, input size,
`cap >= 65536`, eight-byte workspace alignment, signed address-addition bounds,
and nonoverlap of input and used workspace. Numeric pointer checks cannot
establish allocation ownership or OS mapping permissions. Invalid caller memory
is an API contract violation, not a malformed-certificate rejection test.

The checker allocates nothing. It returns `1` for candidate acceptance and `0`
for refusal, modifies workspace, and leaves the input bytes unchanged. Workspace
is reinitialized on every call that passes numeric pointer validation. The CLI
allocates disjoint buffers, reads stdin with a one-byte oversize probe, and uses
this API. It has no other certificate streams or environment-based proof inputs.

| CLI condition | stdout | stderr | Exit |
| --- | --- | --- | --- |
| Candidate derivation accepted | `KERNEL_CHECK=PASS` plus LF | Empty | 0 |
| Certificate refused or input oversized | `KERNEL_CHECK=FAIL` plus LF | Empty | 1 |
| Allocation/read/write failure | No promised complete result line | Empty from application code | 2 |

Successful partial writes are retried. Read errors fail closed. Host runtime
errors and signals are never successful rejection evidence in a mutation test.

## Workspace and source map

Offsets are byte offsets from `work`, with half-open ranges:

| Range | Contents |
| --- | --- |
| `[0,128)` | Parser and kernel counters/masks; unused header words reserved |
| `[128,10368)` | 256 term records, 40 bytes each |
| `[10368,30848)` | 512 formula records, 40 bytes each |
| `[30848,55424)` | 256 ground values, 96 bytes each |
| `[55424,63616)` | 256 proof records, 32 bytes each |
| `[63616,63856)` | 30 assumption-stack line references |
| `[63856,64048)` | 24 multiplication temporary limbs |
| `[64048,65536)` | Cleared reserved space |

Term/formula records contain `(tag,a,b,required_binders,depth)`. Proof records
contain `(formula,dependency_mask,creation_context_mask,assumption_bit)`.
All fields are i64. The highest cleared byte is offset 65535; the highest
currently used record byte is offset 64047.

| Source function | Responsibility |
| --- | --- |
| `nd_number` | Canonical bounded integer-line parsing |
| `nd_add`, `nd_multiply`, `nd_values_equal`, `nd_positive` | Checked exact ground arithmetic |
| `nd_read_terms`, `nd_read_formulas` | Acyclic AST validation, metadata and ground evaluation |
| `nd_step`, `nd_term_match`, `nd_formula_match`, `nd_same` | Budgeted structural identity and capture-safe instantiation |
| `nd_premise` | Prior-reference and active-scope checks |
| `nd_read_proof` | Rule dispatch, dependency union, fresh assumption bits and discharge |
| `finite_nd_check` | API guards, complete parsing, closed goal and final acceptance |
| CLI `main`, `nd_emit` | Bounded stdin capture and explicit output/exit handling |

The minimal build source package consists of `Mind.toml`, `src/main.mind` and
`src/kernel.mind`. Documentation and test fixtures are separate evidence. The
official pinned compiler and its documented CPU backend/build dependencies
remain in the trusted computing base; this source package vendors none of them.
