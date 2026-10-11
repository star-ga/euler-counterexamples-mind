# Finite ND fixture contract

Author: STARGA Inc.

This contract was enumerated before native execution. Expected results are specification judgments, not observed results. Acceptance remains subject to project proof policy. Certificates use canonical decimal LF records and contain no trusted receipt flags. Static fixtures were initially authored with an external JavaScript formatter; the formatter is not a runtime or theorem authority and is not needed to execute the MIND suite.

The suite contains 8 expected accepts and 49 expected rejects, followed by six API bounds/aliasing controls. Every proper prefix and single-byte nondecimal substitution of P01 is rejected as two supplementary exhaustive finite campaigns. Original P01 is rechecked at the end.

The API controls are workspace capacity 65535, input length 65537, null input,
unaligned workspace, overlapping input/workspace, and negative input length.
Backing allocations remain valid; the pointer ownership precondition is never
deliberately violated. The 765-byte P01 supplies 765 proper-prefix controls and
765 nondecimal-byte substitution controls. Total expected rejects: 49 + 6 +
765 + 765 = 1585. Eight initial accepts plus one restored-Euler accept must
complete with normal process exit 0. A crash or early return cannot satisfy
the final exact-count checks.

| ID | Fixture | Expected | Reason |
|---|---|---|---|
| P01 | euler_c4_refutation | ACCEPT | Exact C4 AST, four bound-variable instantiations, four positive integer premises, recomputed quartic equality, contradiction and discharge. |
| P02 | positive_numeral | ACCEPT | Ground integer positivity 7 > 0. |
| P03 | unrelated_addition | ACCEPT | Exact ground arithmetic 2 + 3 = 5. |
| P04 | noncontradiction | ACCEPT | Generic natural-deduction theorem not(P and not P), P := 1 > 0. |
| P05 | not_bottom | ACCEPT | Bottom implies Bottom, represented as not Bottom. |
| P06 | nested_binders | ACCEPT | Nested forall x forall y: instantiate outer 2 under y, then inner 3; prove not(forall x y not(x+y=x+y)). |
| P07 | conjunction_projection | ACCEPT | Independent conjunction introduction and right elimination. |
| P08 | zero_equality | ACCEPT | Zero arithmetic is valid even though strict positivity at zero is invalid. |
| N01 | forged_ground_equality | REJECT | Reject false 0=1 submitted under GROUND_EQ. |
| N02 | zero_positive | REJECT | Reject false strict positivity at zero. |
| N03 | invalid_instantiation | REJECT | False theorem not(forall x x=x): FORALL_ELIM forges Bottom. |
| N04 | witness_mismatch | REJECT | Instantiate forall x not Pos(x) at 0 but claim not Pos(1); invalid derivation despite true final theorem. |
| N05 | popped_scope_false_goal | REJECT | After discharge, reuse an assumption-dependent Pos(0); false final goal. |
| N06 | wrong_discharge_formula | REJECT | Discharge Bottom while claiming not Pos(1), a false final theorem. |
| N07 | reused_scope_depth | REJECT | Reopen same stack depth with fresh assumption; stale Bottom must remain inaccessible; final not Pos(1) is false. |
| N08 | unused_open_assumption | REJECT | Ground valid final goal cannot hide an undischarged unused assumption. |
| N09 | future_premise | REJECT | Conjunction introduction references a future proof line. |
| N10 | self_premise | REJECT | Conjunction introduction references itself. |
| N11 | wrong_conjunction_side | REJECT | AND_RIGHT cannot return the left conjunct. |
| N12 | modus_ponens_nonimplication | REJECT | IMP_ELIM first premise must be an implication. |
| N13 | modus_ponens_wrong_argument | REJECT | IMP_ELIM argument is not its antecedent. |
| N14 | goal_mismatch | REJECT | Final formula and declared goal differ. |
| N15 | signed_literal | REJECT | Signed numeral encoding is outside the supported nonnegative ground fragment. |
| N16 | term_forward_self_reference | REJECT | Terms must reference strictly earlier terms. |
| N17 | formula_forward_self_reference | REJECT | Formulas must reference strictly earlier formulas. |
| N18 | free_variable_result | REJECT | Every proof result and goal must be closed. |
| N19 | open_instantiation_term | REJECT | FORALL_ELIM witness cannot contain a free de Bruijn variable. |
| N20 | unexpected_auxiliary | REJECT | Ground proof rules require zero reserved operands. |
| N21 | unknown_rule | REJECT | Reject unknown proof opcode. |
| N22 | unknown_term_tag | REJECT | Reject unknown term opcode. |
| N23 | unknown_formula_tag | REJECT | Reject unknown formula opcode. |
| N24 | out_of_order_discharge | REJECT | Only the top assumption occurrence can be discharged. |
| N25 | ground_multiplication_overflow | REJECT | 999999^8 exceeds twelve base-1000 limbs; equal overflowed expressions must refuse. |
| N26 | term_depth_limit | REJECT | Reject depth beyond the declared bound even when arithmetic value is zero. |
| N27 | formula_depth_limit | REJECT | Reject formula depth beyond the declared bound. |
| N28 | assumption_id_limit | REJECT | Reject 31 assumption occurrences (maximum 30). |
| N29 | euler_changed_witness | REJECT | Changed positive witness is recomputed, not trusted from the benchmark name. |
| N30 | euler_first_witness_binding | REJECT | Euler first FORALL_ELIM witness differs from the instantiated body. |
| N31 | euler_removed_positivity | REJECT | Euler proof must check all four strict-positive premises, including the first. |
| N32 | wrong_magic | REJECT | Reject unrecognized wire magic. |
| N33 | wrong_version | REJECT | Reject unsupported wire version. |
| N34 | leading_zero | REJECT | Reject noncanonical decimal. |
| N35 | negative_decimal | REJECT | Reject sign characters. |
| N36 | crlf | REJECT | Reject CRLF; grammar is decimal LF only. |
| N37 | empty_line | REJECT | Reject empty numeric token. |
| N38 | missing_final_lf | REJECT | Reject unterminated final numeric token. |
| N39 | trailing_lf | REJECT | Reject extra whitespace after the complete certificate. |
| N40 | trailing_number | REJECT | Reject additional numeric token after the proof. |
| N41 | wide_number | REJECT | Reject decimal above 999999 without overflow. |
| N42 | term_count_limit | REJECT | Reject declared term count beyond capacity before reading missing payload. |
| N43 | zero_terms | REJECT | Reject empty term table. |
| N44 | formula_count_limit | REJECT | Reject formula count beyond capacity. |
| N45 | proof_count_limit | REJECT | Reject proof count beyond capacity. |
| N46 | ground_rule_wrong_shape | REJECT | GROUND_EQ cannot introduce Bottom. |
| N47 | nested_binder_wrong_witness | REJECT | Nested substitution retains exact outer witness, preventing capture or wrong binder replacement. |
| N48 | nonzero_reserved_field | REJECT | GT0 formula reserved b field must be zero. |
| N49 | closed_creation_context | REJECT | Reuse Bottom created within a popped inner scope although dependencies remain active; strict scope violation, not a false final theorem. |
