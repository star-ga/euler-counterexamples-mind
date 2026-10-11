# Candidate finite natural-deduction kernel: architecture review

Author: STARGA Inc.

Review date: 2026-10-11. This is an independent design review, written before implementation inspection or execution. It is not proof-policy approval.

## Semantic statement and trust boundary

Interpret terms in the ordinary unbounded integers. Numerals denote their nonnegative integer values; variables use de Bruijn environments; addition and multiplication have their exact integer meanings. Interpret `Pos(t)` as `t > 0`, equality as integer equality, Bottom as false, conjunction and implication with their usual meanings, and Forall over every integer. Negation is implication to Bottom. Lack of negative numeral syntax restricts supported ground instantiations; it does not restrict the universal quantifier to natural numbers or bounded machine values.

For each accepted proof line, establish the invariant that its formula is entailed by its recorded open assumptions. Every recorded dependency must be a currently active assumption occurrence. The program may conservatively require the entire creation context to remain active, even when a line's minimal dependencies are smaller. That additional restriction loses some reusable derivations but cannot add invalid ones.

Final acceptance needs a closed formula, no undischarged assumptions, no dependencies, and complete structural equality with the submitted goal. A separate benchmark statement binding must show that this goal is exactly the negation of the intended C4 sentence. The generic kernel must not contain an Euler theorem identifier or recognize a fixed Euler derivation.

## Rule-by-rule obligations

1. **Assume.** Add a fresh assumption occurrence with the claimed closed formula. Its dependency mask is exactly that occurrence's globally fresh bit. Push the occurrence, not merely the formula, onto the scope stack. Bits cannot be reused after discharge.
2. **Ground positivity.** Accept only a ground term whose exact checked evaluation succeeds and is strictly positive. The line has no logical dependencies. Zero is not positive.
3. **Ground equality.** Recompute both ground terms independently. Accept only successful exact values with all limbs equal. Neither a certificate assertion nor an unchecked equality flag supplies a premise.
4. **Conjunction introduction.** Both premises must already exist and be available. The claimed result must structurally be their ordered conjunction; dependencies are their union.
5. **Left conjunction elimination.** Available premise must have conjunction shape; the result is its exact left formula with the premise's dependencies.
6. **Right conjunction elimination.** The corresponding exact right formula is required.
7. **Implication elimination.** Available first premise must structurally be A implies B. The available second premise must be A, and the result B. Union both dependency masks; reject antecedent, direction, or consequent mismatches.
8. **Closed-ground universal elimination.** Available first premise must be Forall(body). The witness must be a closed term. The result is the capture-safe substitution of that term for the removed binder, with the premise's dependencies. At nested-binder depth k, substitute Var(k), decrement Var(i) when i>k, and retain Var(i) when i<k. Recurse through all term and formula constructors. Closed replacements require no variable lifting, but outer-index decrement is still essential.
9. **Negation introduction.** Require the supplied assumption occurrence to be the actual top of the stack. Require an available Bottom derivation while that assumption is still active. The result must be exactly Imp(the discharged assumption's formula, Bottom). Remove only that occurrence's bit, then pop it. Discharging an unused assumption is sound weakening; any stricter restriction must be documented. A caller cannot choose an unrelated antecedent or discard another active bit.

## Representation and implementation obligations

- Reject unknown tags, noncanonical or overflowing scalar tokens, nonzero unused fields, out-of-range indexes, cycles/forward references, malformed kinds, unclosed proof formulas, excess depth/nodes/steps/assumptions, and any trailing bytes. Inspect shape and indexes before dereferencing.
- Use a bounded global work budget on all potentially exponential recursive traversals, not solely final equality. A compact acyclic DAG of depth 32 can still expand exponentially when recursively unfolded without memoization.
- Bound the unique assumption-bit count below the signed-word shift/sign boundary. Derive masks internally. Verify both dependency and creation-context availability before reading a premise, including before negation discharge.
- Structural comparison may reject syntactically different but mathematically equivalent expressions. It must not accept different ASTs solely because they share a node index, numeric value, or certificate-provided identity.
- Check every scratch offset and all indexing arithmetic; document allocation requirements, maximal accessed offset, and input/work-buffer non-overlap if that is an API precondition. Exhaustion or invalidity must produce refusal, never acceptance via a default branch.

## Exact arithmetic bridge

Twelve normalized base-1000 limbs represent exactly the interval [0, 1000^12). An accepted addition or multiplication must equal the ordinary integer result and reject nonzero discarded high limbs/carry. The proof of the old small-multiplier checker does not establish general term-by-term multiplication. Inspect the actual convolution/carry algorithm and prove its scalar intermediates fit signed i64. Arithmetic refusal is incompleteness, not evidence that the integer formula is false.

Because only nonnegative numerals, addition, and multiplication are ground-evaluated, no signed-magnitude implementation is required for this witness. The semantic bridge is the embedding of these exact nonnegative computations into Z. Universal formulas still range over all integers.

## Required adversarial evidence

At minimum: zero positivity; forged ground equality; swapped/mismatched implication operands; wrong conjunction projection; non-universal instantiation; open witness; wrong witness; retained/dropped/captured de Bruijn index; out-of-scope premises; reference to a future line; wrong or non-top discharge; unmatched final assumptions; forged result/goal; overflow; malformed framing; and bounded traversal exhaustion. Include positive nested-binder and multiple-scope examples so over-restrictive implementations cannot masquerade as successful fault detection.

Actual source mutants must build and exit normally. Separately demonstrate acceptance of the targeted invalid proof by each faulty implementation; build failure, crash, blanket rejection, or an unrelated mismatch is not fault detection. Preserve frozen baseline cases and document any later additions/corrections.

## Policy residual

`PROOF_POLICY.md` still blocks NATIVE_VERIFIED until owner/designated-verifier approval of soundness rules, axiom handling, syntax, dependency closure, trusted computing base, and independent validation. This review, successful compilation, and tests do not waive that requirement. The compiler, CPU lowering/runtime, integer/heap semantics, kernel implementation, wrapper goal binding, and arithmetic algorithm remain in the implementation trust chain.
