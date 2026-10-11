# Soundness argument for the polynomial rule

Author: STARGA Inc.

This is a prose argument about the specified calculus and implementation. It is
not a machine-checked metatheorem or an authorization of `NATIVE_VERIFIED`.
The existing [NDv1 argument](../finite_nd/SOUNDNESS.md) supplies parsing,
closed-term substitution, exact limb arithmetic, propositional rules and scope
invariants. The extension below adds a universally closed polynomial-equality
rule; it does not relax the requirement that every proof line be closed.

## Integer interpretation

For any environment rho in Z^4, interpret a monomial `(e0,e1,e2,e3)` as
the product of rho[j]^ej. Exponent zero contributes 1, including at rho[j]=0.
Interpret a polynomial as the finite sum of its coefficient times monomial
interpretation. Coefficients are natural numbers, but rho is arbitrary signed
integer data. This is the ordinary commutative-ring interpretation in Z.

The base-33 encoding is injective on exponent vectors in {0,...,32}^4: positional
representation uniquely recovers each digit. Product keys are formed only after
checking each component sum <=32; adding packed keys without that check would
be invalid because carry could change the variable. The largest key is
33^4-1=1,185,920, and all key/offset/counter arithmetic is in signed-i64 range.

## Representation and arithmetic lemmas

An initialized cache entry has count <=128, strictly increasing distinct keys,
and nonzero coefficients represented canonically by twelve digits in 0..999.
The empty entry denotes zero. Original checked limb addition/multiplication
preserve exact values below 10^36 and refuse overflow. Their largest scalar
intermediate remains 999999. Addition with the output aliasing its first input
is safe: at iteration i only that input limb i is read and overwritten, and the
future input limbs remain untouched. A failed partial write is never accepted.

Insertion of a zero coefficient leaves the entry unchanged. Inserting a new
key finds its ordered position and shifts initialized records in descending
index order before writing the new record. The destination cannot overwrite a
record still needed by the shift. Existing equal keys are combined by exact
addition; positive coefficients cannot cancel. Consequently successful insertion
preserves the representation invariant and adds exactly the supplied monomial.
Any capacity, work or arithmetic failure aborts the certificate.

Merging a source polynomial inserts each source monomial into a distinct output
entry. Induction on source records proves that merging adds its interpretation.
Convolution visits each ordered pair of source monomials once. It checks exponent
sums, multiplies exact coefficients, and inserts the product. Distributivity and
the laws of nonnegative integer powers over Z prove that its resulting
interpretation is the product of the two source interpretations. Aliased source
children (such as t*t) are allowed; neither is the destination because children
are strictly earlier terms.

## Normalization lemma

Proceed by induction on the topological term declarations. A numeral becomes
its exact constant polynomial. Variable index j becomes coefficient 1 at the key
for Xj, without evaluating it at a guessed value. Addition and multiplication
use the successful merge/convolution lemmas applied to the earlier children.
Thus, for every rho in Z^4, interpreting a successfully computed normal form
equals interpreting its source AST under rho. Zero multiplication, repeated
monomials and shared DAG children follow from the same induction.

The count is reset before each entry is built. All coefficient records are
initialized before becoming visible through that count. The cache-complete flag
is set only after all declared terms succeed and is cleared at every API entry.
Consequently neither uninitialized workspace nor a previous certificate supplies
an accepted normal form. Normalizing unused terms is conservative refusal; it
does not grant facts. Work limits can reduce completeness but not justify an
otherwise unchecked conclusion.

If two canonical lists have equal lengths, all keys equal and all twelve limbs
of every coefficient equal, they have identical interpretations for every rho.
Combining this fact with the normalization lemma proves L(rho)=R(rho) for every
integer assignment. Only this forward implication is needed for soundness;
no claim that the implementation recognizes every possible true identity is
required.

## Universal closure and proof contexts

POLY_ID requires one to four enclosing Forall constructors with an equality
body. The original binder-demand check proves that the entire result is closed;
the rule also checks that the body requires no more than the actual binder count.
Every variable occurrence is therefore covered by a universal binder. Equality
for every rho entails the nested universal statement, including vacuous binders.
There is no eigenvariable side condition to omit: this restricted rule proves
the universally closed formula directly through symbolic normalization. It does
not introduce an arbitrary open sequent into the natural-deduction calculus.

The new conclusion has an empty dependency set. Like all other lines, it records
its active creation context and can only be referenced while that context is
available. It cannot discharge assumptions, assert an implication or supply
Bottom. All unused proof fields must be zero. Subsequent original rules continue
to preserve the NDv1 sequent invariant. In particular, FORALL_ELIM checks a
closed replacement term and the exact capture-safe result AST, rather than using
polynomial equivalence as a substitution shortcut.

Ground arithmetic still refuses open operands explicitly, in addition to the
unchanged global closed-proof-line check. This prevents the audit's dangerous
shortcut in which unevaluated variable buffers could be read as numeric zeros.
Version 1 refuses POLY_ID and version 2 is a separate entry contract. Final
acceptance requires a closed declared goal, exact EOF, empty assumption scope,
zero final dependencies and structural equality with the final proof result.

Under these lemmas and the documented implementation/compiler/runtime assumptions,
acceptance implies the declared formula is true in the intended integer model.
Source review, adversarial tests and mutation outcomes provide implementation
evidence; they are not a formal proof of the normalization program or its compiler.
The owner/designated-verifier acceptance obligations remain open.
