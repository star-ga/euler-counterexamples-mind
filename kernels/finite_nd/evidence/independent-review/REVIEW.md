# Independent review: finite natural-deduction candidate

Author: STARGA Inc.

Publication disclosure: review was performed by an AI agent assigned separately
from implementation. It was not external human validation. Any approval still
follows the public PROOF_POLICY.md.

Review date: 2026-10-11. Scope: complete source and semantic-argument review, exact Euler statement binding, an independently authored 33-case native test run, the complete implementer harness independently rerun, and eight source mutants independently rerun. This document does not authorize project proof-status promotion.

## Reviewed identity

| Artifact | SHA-256 |
| --- | --- |
| `kernels/finite_nd/src/kernel.mind` | `ca181abc7430c32c324d10653fba3cca47cbf9a2d2cea30a5c97ec0ac4e13128` |
| Generic CLI `src/main.mind` | `a4409fc9914c380ba0b45e5c9ed9f9b5242882cde70b9a38a6897aeb77bc9e59` |
| Exact Euler certificate `P01_euler_c4_refutation.nd.txt` | `e76cf839db6c67777d059a88da9a7a14bfd631ac4dadea4409d8028f5f8903a4` |
| Independent 33-case prelist | `a22494985ab4fdb2c891631e6ffd10307a918b1ebe80254282f1c39fd4ac75dd` |
| Independent MIND probe | `64aafbd1dfa9203f726501de0cf9b99f88e802575905ade45e7d8d50b0622bb3` |
| Pinned compiler | `a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa` |
| Independent probe ELF | `426668759061969baa10cfaac11495f3da2b6de52c888296e2dc1b12153a3dba` |
| Complete suite source | `54d127108b1859a26c1b98be955dd9d9678d8fc5d13bde58acf7b68906addcfe` |
| Complete suite fixture module | `3f5bc4cc4cd4e8d3ab742520110b8c5e25fcf0f5f9caedf6b75771877904e69b` |
| Complete suite final source manifest | `57c617b2eaba819a56adbfd36e4c59d3e7895918721f5b09ca9b54cf1f354f76` |
| Complete suite ELF | `59b9f31e9f986a27327fbe387f71e630ac3607037011bec5d4c7b9dbe3be03d0` |

## Source and mathematical findings

No concrete incorrect-acceptance defect was found in the reviewed source. This is a bounded independent review conclusion, not a machine-checked metatheorem or proof of complete implementation correctness.

The syntax and semantic argument in `SOUNDNESS.md` correspond to the implementation. Quantifiers range over unbounded Z. The nonnegative ground evaluator is a partial exact arithmetic procedure used only for supported closed terms. It does not replace Z by a finite or nonnegative quantifier domain. Negation introduction and the remaining rules are constructive; neither excluded middle nor double-negation elimination is used.

`nd_read_terms` and `nd_read_formulas` (kernel lines 116–199) validate tags, fields and strictly earlier node references before reading child metadata. Minimum required binder counts are computed topologically. Count zero exactly characterizes closed syntax: variables contribute index+1, binary constructors take maxima, and a quantifier decreases a positive requirement by one. Every accepted proof result and final goal is closed. Ground arithmetic is evaluated once in node order rather than recursively expanding shared DAGs.

The parser (lines 17–42) accepts canonical unsigned decimal lines only, checks before multiplication by ten, and bounds every scalar by 999999. Empty tokens, signs, leading zeroes, CRLF and unterminated tokens refuse. Table and proof capacities are checked before loops. Final cursor equality (line 397) refuses all trailing bytes. A 65536-byte CLI input is probed for one extra byte before checking, so truncating a larger input cannot turn it into a valid certificate.

Arithmetic was reviewed separately from the earlier Euler template checker. The twelve-limb addition routine bounds each scalar sum by 1999 and rejects final carry. The multiplication routine uses 24 normalized limbs; each scalar expression is at most `999*999 + 999 + 999 = 999999`. Before outer row i, earlier rows have touched positions at most i+11; position i+12 is therefore zero when the final row carry is written. Induction on the inner prefix and then outer rows yields the exact full product. All high limbs 12 through 23 must vanish before low limbs are copied. These operations are exact in signed i64 under the documented compiler semantics. Positivity requires a nonzero canonical vector; ground equality compares all limbs of the actual selected terms.

Structural matching (lines 203–256) checks constructors and fields, spends one shared comparison budget, and has no node-index equality bypass. Universal elimination (lines 316–321) requires a universal premise, closed witness and closed result, then compares the entire substituted body. Nested binder depth is increased only when traversing Forall. At that depth the removed variable is replaced with the exact closed witness and lower indices remain bound locally. The general helper also correctly decrements higher indices; that latter branch cannot occur through the current public proof API because the universal premise is closed and its removed binder is outermost. A mutation solely of this unreachable branch is not a meaningful required public-API fault test.

Assumption bits (lines 287–295) are assigned monotonically, capped at 30, and never reused when a scope closes. Dependencies and creation context must both remain active before a premise can be referenced (lines 258–267). The latter restriction is deliberately conservative: even a dependency-free result created inside a closed lexical scope cannot be reused later. It restricts completeness, not soundness. Implication and conjunction rules structurally bind all required premises and results. Negation introduction (lines 342–355) checks both premises before popping, requires the exact top assumption occurrence and actual Bottom premise, binds the result to that assumed formula implying Bottom, and removes only that assumption's dependency bit. Final acceptance requires empty active mask and stack, zero final dependencies, and structural goal equality.

The 65536-byte workspace clear is the maximal write; actual records end at offset 64047. Tables, assumption stack and multiplication temporary do not overlap. Numeric pointer overflow, alignment and input/work overlap are checked, while readable/writable allocation ownership remains an explicit internal API precondition. No certificate field is treated as a pointer. Bound exhaustion yields refusal.

## Exact Euler statement binding

An independent raw certificate decode consumed all 317 scalar records: 31 terms, 46 formulas and 16 proof lines. It agrees with `EULER_TABLES.md`. Within four nested quantifiers, T1=v3 denotes a, T2=v2 denotes b, T3=v1 denotes c and T4=v0 denotes d. F15 is exactly

`forall a,b,c,d:Z. (((a>0 and b>0) and (c>0 and d>0)) -> ((((a*a)*(a*a) + (b*b)*(b*b)) + (c*c)*(c*c) = (d*d)*(d*d)) -> Bottom))`.

F46 is `Imp(F15,Bottom)`, the declared and final goal. The ordered ground instantiations use 95800, 217519, 414560 and 422481. Lines 6–9 prove their four strict positivities; lines 10–12 construct the exact conjunction; line 13 computes the exact quartic equality; lines 14–15 derive Bottom from C4 and those premises; line 16 discharges the only assumption C4. Ground arithmetic facts are therefore structurally bound into the contradiction, rather than accepted as unrelated numeric checks.

The independent decode is a review aid, not a second theorem checker. A generic CLI accepting arbitrary caller goals does not label all successful inputs as Euler refutations. Claims about this benchmark are bound to the exact reviewed fixture hash above. Supporting a freely replaceable Euler input with a fixed Euler label would require an additional independently reviewed expected-statement binding; no such broader claim is made here.

## Independent native evidence

The reviewer froze the 33-case list and static MIND harness before the first build/run. A one-shot external formatter wrote static fixture text; it is not used by the build or executable. Every expected-versus-actual decision ran in the MIND harness calling the kernel API. The frozen kernel was copied into a separate scratch project, preserving implementation ownership.

Fresh build: exit 0, empty stderr, 1.95 seconds, peak RSS 120144 KiB. Fresh run: exit 0, empty stderr, all 33 decisions matched, 0.01 seconds, peak RSS 8192 KiB. Build used one CPU, nice 19, 1 GiB address-space limit and 30-second wall timeout; execution used one CPU, 256 MiB address-space limit and 15-second wall timeout. No crash, signal, timeout or failed build is counted as a passing refusal.

The suite independently covers exact maximum twelve-limb positivity (`1000^12-1`), addition overflow, multiplication overflow with false claimed equality `1000^12=0`, carries, false ground equality, zero positivity, a generic non-Euler logical theorem, nested binder preservation, incorrect/open witnesses, a stale-scope attack claiming false `not(1>0)`, wrong negation antecedent, non-Bottom discharge, undischarged assumptions, structurally identical duplicate nodes, unequal goals that are both mathematically true, syntactically different equal-valued terms, malformed framing/references, and depth/comparison-budget refusals. The shared-DAG resource case is logically valid but intentionally refused by the supported bound; it is not called a false theorem.

The complete implementer suite was also reviewed and independently rerun. All 57 static certificate strings byte-match their raw fixture files. Its rejection count is exactly 49 static negatives + 6 API contract controls + 765 proper prefixes + 765 single-byte nondecimal substitutions = 1585. There are eight counted static positive controls and one additional restored-Euler acceptance at the end. The independent rerun exited zero with empty stderr, and stdout/stderr/exit matched the integration receipts byte-for-byte. It used the same one-CPU, 256 MiB execution profile. No frozen expected case was relaxed.

The initial suite builds failed before execution because imported helpers required public visibility and conventional `src/` staging with entry `src/main.mind`. Those failures and source-manifest history are retained in the integration evidence and `tests/TEST_ADJUSTMENTS.md`; they are not passing tests. The final source change was helper visibility, and the staging/manifest change placed the same test logic in `src/`. Certificate bytes and expected results remained unchanged. As a minor coverage qualification, N15 tests a nonzero reserved numeral field; signed-token rejection is separately exercised by N35. Neither count is advertised as exhaustive proof of parsing correctness.

## Actual source mutants

The reviewer checked all eight mutation-source files against exactly one application of their recorded source diff to the frozen kernel. Each retained the identical generic CLI. All source and executable hashes matched the campaign receipts; all eight builds exited zero with empty stderr. No mutant was a substituted prebuilt receipt or a modified certificate expectation.

Twenty-six independent reruns covered baseline Euler, baseline unrelated positivity, and baseline-bad / mutant-positive / mutant-bad for each mutant. Every baseline bad fixture exited 1 with `KERNEL_CHECK=FAIL`; every mutant accepted both its positive control and targeted bad fixture with exit 0 and `KERNEL_CHECK=PASS`. All stderr streams were empty. All 78 stdout/stderr/exit fields exactly matched the separately captured integration receipts. These were normal returns, not crashes or timeouts.

| Mutant | Removed obligation | Independently observed consequence |
| --- | --- | --- |
| M01 | Complete instantiated-result comparison | Accepts the false theorem `not(forall x:Z. x=x)`. |
| M02 | Exact replacement-term comparison | Accepts a derivation claiming the body at one after instantiating at zero. The final theorem happens to be true; this demonstrates invalid inference acceptance, not a false theorem. |
| M03 | Recomputed ground equality comparison | Accepts false `0=1`. |
| M04 | Creation-context accessibility | Accepts a line from a popped inner lexical scope whose logical dependencies remain active. This violates the documented stricter calculus restriction; the final theorem is true. |
| M05 | Actual discharged antecedent binding | Discharges Bottom but accepts false `not(1>0)`. |
| M06 | Strict positivity comparison | Accepts false `0>0`. |
| M07 | Exact end-of-input comparison | Accepts an extra trailing LF. This is a framing violation, not a false-theorem claim. |
| M08 | Globally fresh assumption identity | Reusing stack depth revives old Bottom under a different assumption and accepts false `not(1>0)`. |

These eight controls exercise actual faulty acceptance while preserving positive controls. They do not imply a complete mutation score over all conceivable kernel faults. In particular, the unreachable higher-index decrement branch is not counted as a tested mutant.

## Residual obligations and independence limits

This review is independent of implementation and test authorship, but uses the same machine, compiler bytes, CPU backend, runtime and integer semantics. It is not independent-machine or independent-compiler verification. The mathematical soundness argument is prose and the compiler/runtime are not formally verified by this work. Tests establish specified finite outcomes, not universal software correctness.

`the root PROOF_POLICY.md` continues to block NATIVE_VERIFIED. Owner/designated-verifier approval of soundness rules, axiom handling, certificate syntax, dependency closure, TCB and independent validation is still required. This is a concrete candidate calculus and derivation for that approval; reviewer agreement does not supply it. `FORMAL_PROOF_SUBMITTED` accurately describes a candidate formal derivation submitted with this evidence, while acceptance is pending. The prior fixed-template recognizer remains a separate historical engineering artifact. No RH progress follows.

## Review status

Source, rulewise semantic argument, exact Euler statement binding, independent 33-case execution, complete implementer harness, and eight source-mutant campaigns: **PASS WITH NOTES**, scoped as above. Formal project acceptance: **BLOCKED BY EXISTING PROOF POLICY**. No mandatory implementation correction remains from this review.
