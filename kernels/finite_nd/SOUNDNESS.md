# Soundness argument for the supported calculus

Author: STARGA Inc.

This is a mathematical argument about the specified kernel, with its
implementation correspondence subject to independent review. It is not itself
a machine-checked metatheorem and does not authorize NATIVE_VERIFIED. The exact
implementation and review hashes are recorded with execution evidence.

## Syntax, interpretation and well-formedness

Terms are nonnegative integer numerals, de Bruijn variables, addition and
multiplication. Formulas are positivity, equality, bottom, conjunction,
implication and universal quantification over Z. Under an integer environment
rho, variable k denotes rho[k]; entering a quantifier prepends its integer to
rho. Other term and formula constructors have their ordinary integer and
logical meanings. A closed formula has no free de Bruijn index.

Nodes reference earlier nodes of the appropriate kind. Induction on node order
therefore defines finite syntax. A term's required binder count is zero for a
numeral, k+1 for variable k, and the maximum of its children's counts for a
binary term. Atomic formulas inherit their terms' counts; binary formulas take
the maximum; forall reduces a positive count by one, floored at zero. Induction
on syntax proves that a root count of zero is exactly closedness. Every proof
line and goal must be closed. Open intermediate AST nodes are only syntax,
never accepted sequents. Syntax/resource failures cause refusal.

`nd_term_match` and `nd_formula_match` compare every constructor and field
recursively. Successful ordinary comparison implies identical syntax by
structural induction. There is no pointer/index-equality shortcut. A finite
comparison budget may cause false refusal but cannot authorize acceptance.

## Closed-term substitution lemma

To remove the outer binder from `forall A`, traverse A at nesting depth j.
Variable k is unchanged if k<j; if k=j replace it by the supplied closed term t;
if k>j replace it by variable k-1. Descending under another forall increments j.
The replacement has no free variable, so it cannot be captured and requires no
lifting. Numerals and other constructors are preserved recursively. Induction
on terms and formulas proves that evaluating the substituted A under rho is
the same as evaluating A with the value of t inserted at the removed binder.

The implementation compares the declared result to this substitution at every
node, instead of trusting a supplied instantiated formula. It separately checks
that the premise is a forall, the replacement is closed, and the result is
closed. Thus it cannot exchange witnesses, skip occurrences or change a
connective without refusal. Restricting substitution to closed terms is a
sound restriction of universal elimination, not an assertion that variables
range only over representable numerals.

## Exact arithmetic-to-logic bridge

For a limb vector x, define V(x)=sum(i=0..11, x[i]*1000^i), with every limb in
0..999. Ground AST nodes are evaluated in topological order. A literal n is
stored as (n mod 1000, n div 1000, 0,...,0); the parser restricts n to 0..999999,
so these limbs have V=n. Variables have positive binder demand and are never
accepted as ground arithmetic premises.

For addition, the loop computes each output limb and carry from
`v = x[i]+y[i]+carry`. Starting with carry zero, induction gives carry in
{0,1}, v<=1999, and preservation of the represented prefix sum plus its carry.
The final carry must be zero. Therefore successful addition represents the
exact mathematical sum; overflow is refused, not reduced modulo 10^36.

Multiplication uses a zeroed 24-limb accumulator. For each input limb x[i],
the inner loop adds its shifted product with y into the accumulator. With
input/accumulator limbs in 0..999 and incoming carry in 0..999,
`v = x[i]*y[j]+old[i+j]+carry` lies in 0..999999. Division/remainder by 1000
produce a canonical limb and a carry in 0..999. The usual prefix invariant is
that the updated prefix and pending carry represent the old accumulator plus
the processed part of x[i]*1000^i*V(y). Earlier rows cannot have written the
position i+12: their final carry positions are at most i+11. The implementation
checks that this position is zero before writing the final row carry. Induction
on rows yields the exact 24-limb product. All high limbs 12..23 must be zero
before the low twelve are copied, establishing exactness below 10^36.

All intermediates above are below one million and hence below signed i64
maximum. AST indices, offsets and shifts are separately bounded; arithmetic
correctness assumes the pinned compilation implements ordinary exact in-range
i64 operations, positive division/remainder and memory accesses correctly.
Topological induction now proves every successfully evaluated ground term's
limb vector denotes its integer interpretation. Comparing all twelve canonical
limbs proves integer equality; a nonzero vector proves strict positivity because
this evaluator's values are nonnegative. No numeral value, computed power,
equality limb vector, oracle assertion or PASS flag supplied by the certificate
is accepted without this evaluation. Equalities are about the actual terms of
the selected formula, so the arithmetic fact is bound structurally to the
logical premise.

## Sequent invariant and rules

Let each opened assumption occurrence have a fresh identity h, formula A_h,
and a unique bit. Its identity is never reused. For each accepted proof line i,
let D_i be its recorded dependency set. The invariant is: if all A_h for h in
D_i hold, then the line's closed formula holds. A premise may be referenced only
while its dependencies AND its recorded creation scope are active. The latter
restriction deliberately forbids even dependency-free results from a closed
lexical scope; it strengthens refusal and does not weaken soundness.

| Rule | Checked operation | Why its sequent invariant holds |
| --- | --- | --- |
| ASSUME | Open fresh h:A, record D={h} | A follows from the assumption A itself. |
| GROUND_POS | Actual ground term evaluates to a nonzero limb vector | Arithmetic bridge proves its value is strictly positive; D is empty. |
| GROUND_EQ | Actual ground terms evaluate to identical limb vectors | Arithmetic bridge proves equality; D is empty. |
| AND_INTRO | Premises A,B; result structurally A and B; union dependencies | Under their union both premises hold. |
| AND_LEFT / AND_RIGHT | Premise A and B; result structurally selected child | Truth of a conjunction entails each component. |
| IMP_ELIM | Premises A->B and A, structurally matched; result B | Modus ponens preserves truth under the union of dependencies. |
| FORALL_ELIM | Premise forall A, closed t; result checked substitution A[t] | Universal truth includes the integer denoted by t, by the substitution lemma; dependencies unchanged. |
| NEG_INTRO | Current top assumption h:A, available bottom line; result A->bottom; discharge exactly h | With every remaining dependency true, temporarily assuming A satisfies any h-dependency of bottom. The contradiction thus establishes A->bottom without h. |

Negation introduction is also sound for a bottom premise that does not depend
on h (vacuous discharge). It still requires a genuinely open top assumption,
a checked bottom premise in scope, the exact assumed antecedent, and bottom
as consequent. The dependency set is the bottom premise's set with only h
removed. Older assumption identities cannot be revived by reopening the same
formula. Intermediate references must be strictly earlier proof lines.

Induction over the instruction sequence proves the invariant. Final acceptance
requires exact end-of-input, an empty assumption stack and active mask, zero
final dependencies, and structural identity between the final line and the
closed declared goal. Consequently the accepted goal holds in the intended
integer model, PROVIDED the specified rules and their arithmetic/parser/scope
implementation satisfy this argument and the execution TCB operates correctly.
This conditional conclusion is distinct from project authorization of the
kernel, from a formal verification of its source/compiler, and from any claim
that passing adversarial tests establishes universal implementation correctness.

## What is intentionally unsupported

There is no general theorem database, imported axiom rule, proof hole,
universal introduction, existential rule, induction rule, arbitrary signed
ground evaluator or rewriting modulo algebraic equivalence. Equivalent formulas
must still match structurally when a rule requires matching. Unsupported
constructs and exhausted bounds are rejected. These restrictions suffice for
the supplied closed counterexample derivation and reduce the proof surface.
