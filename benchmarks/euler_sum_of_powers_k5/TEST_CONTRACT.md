# K5 frozen test contract

Author: STARGA Inc.

These expected outcomes were enumerated before native execution. Static certificate generation used an external JavaScript formatter; neither that formatter nor its BigInt diagnostic is a runtime or proof authority. Every executable mathematical/test decision is MIND.

The certificate is 1045 bytes. The suite checks 42 static fixtures, each against both the generic kernel and the exact-C5 benchmark wrapper. Expected generic accepts: 10; expected C5-bound accepts: 3. The seven B-cases are valid derivations of other encoded statements: they must pass the generic kernel and fail benchmark binding.

After the static fixtures, all 1045 proper prefixes (lengths0..1044) and all 1045 single-byte substitutions by ASCII X must fail both checks. Then the original bytes must pass both checks. The mutation byte is restored after every substitution. Counts: static 42; prefix 1045; byte corruption 1045; restoration1. Any mismatch, count failure, crash, timeout or build failure fails the campaign. No expected outcome may be changed in response to execution without a separate documented contract revision.

| ID | Generic | C5-bound | Obligation |
|---|---:|---:|---|
| P01_c5_refutation | 1 | 1 | Exact C5 goal and all 19 checked inference steps. |
| P02_redundant_ground_premise | 1 | 1 | Same goal with one additional valid ground premise; binding does not compare complete certificate bytes. |
| P03_unused_ground_term | 1 | 1 | Same theorem with an extra valid unused term, exercising dynamic table offsets. |
| B01_arithmetic_only | 1 | 0 | Exact fifth-power identity alone is accepted generically but is not the declared negation of C5. |
| B02_unrelated_positive | 1 | 0 | A valid positive numeral theorem cannot receive a C5 benchmark label. |
| B03_fourth_power_refutation | 1 | 0 | The valid four-variable K4 refutation is a different goal. |
| B04_missing_positive_hypothesis | 1 | 0 | Valid refutation of the formula with the first positivity hypothesis removed; exact C5 binding must refuse. |
| B05_scaled_equation | 1 | 0 | Valid derivation of an algebraically equivalent, differently encoded scaled equation; exact benchmark syntax requires coefficient one. |
| B06_valid_square_refutation | 1 | 0 | Valid five-variable square-counterexample derivation is not the fifth-power statement. |
| B07_missing_quantifier | 1 | 0 | Valid refutation with first variable fixed to 27, leaving only four universal binders. |
| N01_changed_first_witness | 0 | 0 | Coherently changed witness must fail recomputed ground equality. |
| N02_changed_rhs_witness | 0 | 0 | Coherently changed right witness must fail recomputed equality. |
| N03_fourth_powers | 0 | 0 | The same tuple does not solve the fourth-power equation. |
| N04_sixth_powers | 0 | 0 | The same tuple does not solve the sixth-power equation. |
| N05_double_left_coefficient | 0 | 0 | A coherently doubled left sum must fail recomputed equality; all substitution steps otherwise match. |
| N06_wrong_first_substitution | 0 | 0 | First instantiation supplies84 while claiming the27-substituted formula. |
| N07_wrong_fifth_substitution | 0 | 0 | Last instantiation supplies27 while claiming144. |
| N08_open_witness | 0 | 0 | A free de Bruijn variable is not a permitted closed witness. |
| N09_assumed_positivity | 0 | 0 | Replacing a proved positivity by another assumption leaves an unclosed scope and invalid discharge. |
| N10_zero_positive | 0 | 0 | Zero is not strictly positive. |
| N11_forged_equality | 0 | 0 | The generic ground rule must reject0=1. |
| N12_swapped_conjunction | 0 | 0 | Conjunction introduction cannot silently swap the ordered positivity premises. |
| N13_wrong_implication_argument | 0 | 0 | The equality proof is not the positive-conjunction antecedent. |
| N14_forged_bottom | 0 | 0 | Implication elimination result must be its actual consequent, Bottom. |
| N15_wrong_discharge_occurrence | 0 | 0 | A ground positivity line is not the active assumption occurrence to discharge. |
| N16_wrong_discharge_formula | 0 | 0 | Negation introduction must negate the actual C5 assumption. |
| N17_undischarged_assumption | 0 | 0 | Deriving Bottom under C5 does not close the proof without discharge. |
| N18_popped_creation_scope | 0 | 0 | Closed creation context cannot be reused, even when actual dependencies remain active. |
| N19_self_premise | 0 | 0 | Self-reference is not a prior proof. |
| N20_future_premise | 0 | 0 | Future premise reference is invalid. |
| N21_declared_goal_mismatch | 0 | 0 | The final negated conjecture does not match a declared arithmetic-only goal. |
| N22_free_goal | 0 | 0 | A formula with a free integer variable cannot be the closed goal. |
| N23_wrong_magic | 0 | 0 | Wrong wire magic. |
| N24_wrong_version | 0 | 0 | Unsupported wire version. |
| N25_leading_zero | 0 | 0 | Noncanonical decimal token. |
| N26_trailing_lf | 0 | 0 | Trailing bytes are not permitted. |
| N27_missing_final_lf | 0 | 0 | Final decimal token must be LF-terminated. |
| N28_oversized_decimal | 0 | 0 | Unsigned fields may not exceed999999. |
| N29_term_self_reference | 0 | 0 | Term AST must be acyclic and topological. |
| N30_unknown_formula_tag | 0 | 0 | Unknown formula tag cannot represent equality. |
| N31_crlf | 0 | 0 | CRLF is not canonical LF framing. |
| N32_negative_token | 0 | 0 | Signed wire fields are unsupported. |

## Standalone CLI calls

Before execution, the standalone CLI sequence is fixed: P01_c5_refutation (exit0; C5_BOUND_CERTIFICATE=PASS and FORMAL_ACCEPTANCE=BLOCKED, each LF-terminated), B01_arithmetic_only, B06_valid_square_refutation, N01_changed_first_witness (each exit1; C5_BOUND_CERTIFICATE=FAIL plus LF). All application stderr must be empty. The suite runs once before these four CLI calls. A failure does not authorize skipping any subsequently needed diagnostic; it cannot count as successful rejection.
