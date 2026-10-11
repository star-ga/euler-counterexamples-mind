# K5 independent implementation review

Author: STARGA Inc.
Date: 2026-10-11
Scope: `benchmarks/euler_sum_of_powers_k5/`, inherited finite natural-deduction kernel, published execution receipts, and package-signing orchestration.

**Verdict: PASS for the reviewed candidate implementation and finite engineering evidence. Formal acceptance remains blocked.** No blocking discrepancy was found in the C5 statement binding, witness substitutions, arithmetic derivation, published fixtures, or two actual wrapper mutations.

This review was performed by an automated agent separate from the K5 implementation agent. It is not an authorized independent soundness validation, a machine-checked kernel metatheorem, or an authorization to assign `NATIVE_VERIFIED`. This reviewer did not build or execute the K5 programs. Native results below are inspected receipts, including a separate-machine replay. Read-only JavaScript decoding and integer calculations were external review diagnostics, not project runtime dependencies or theorem authorities. The signing subsection is a contract review by the bridge's implementation agent and is not an independent implementation review of that bridge.

## Exact statement and derivation

The P01 certificate declares the negation of exactly:

```text
C5 := forall a,b,c,d,e : Z.
      ((a>0 and b>0) and ((c>0 and d>0) and e>0))
      -> not((((a^5+b^5)+c^5)+d^5)=e^5).
```

Each fifth power is represented as `((x*x)*(x*x))*x`; negation is implication to Bottom. Inside all five quantifiers the variable indices are a=4, b=3, c=2, d=1, e=0. The quantifiers range over all mathematical integers. The checker's nonnegative ground-expression fragment and finite resource limits restrict certificates it can accept, not this quantified domain.

Independent decoding of the 1,045-byte P01 file found 52 terms, 61 formulas and 19 proof instructions, with exact canonical framing. Formula 18 is C5; formula 61 is `Imp(F18, Bottom)`. All 52 term-table and 61 formula-table documentation rows agree with the encoded certificate. Starting from the assumed C5, the five universal eliminations are:

```text
F18 --27--> F28 --84--> F37 --110--> F46 --133--> F54 --144--> F60.
```

Each substitution was independently compared as an AST transformation, including binder depth and index decrement. All five match. Ground positivity proves the five positive witnesses; conjunction introduction reconstructs the exact antecedent. Ground equality recomputes:

```text
27^5  =    14,348,907
84^5  = 4,182,119,424
110^5 =16,105,100,000
133^5 =41,615,795,893
144^5 =61,917,364,224
```

The first four sum to 61,917,364,224. Modus ponens derives the negated ground equality from the instantiated assumption and positivity, then Bottom from the independently checked equality. Negation introduction discharges the sole C5 assumption. No open assumption or free variable remains. The inference does not require excluded middle.

The wrapper first requires generic kernel acceptance and then inspects the validated AST. It checks five quantifiers, all five positivity atoms in the specified grouping, unit coefficients, four addends, the exact fifth-power structure, matching variables and the RHS. It therefore prevents an unrelated accepted derivation from receiving a C5 label. Redundant valid premises and unused valid terms are permitted, so this is structural statement binding rather than a whole-certificate byte lock. Syntactically different but mathematically equivalent formulations are intentionally outside this profile.

The inherited kernel source is unchanged. Its 12 base-1000 limbs and checked carries bound each add step by 1,999 and multiplication inner step by 999,999. Upper temporary limbs are checked before accepting a product. These witness computations are comfortably within the accepted range. Scope checking retains distinct assumption occurrence IDs, dependency and creation-context checks, top-of-stack discharge, exact discharge-formula matching and a closed final conclusion. The new wrapper adds no inference rule.

## Test and mutation evidence

All 42 embedded fixture strings byte-match their published certificate files. The frozen static list comprises three accepted C5 derivations, seven accepted generic derivations with other goals, and 32 invalid derivations. Wrong-goal controls include arithmetic alone, an unrelated positivity result, K4, a missing positivity hypothesis, a scaled equation, squares in place of fifth powers, and one missing quantifier. Invalid derivations cover altered witnesses and powers, coefficient changes, substitution and binding errors, unproved positivity, forged equality/Bottom, scope and discharge errors, forward references, goal mismatch, free variables and malformed encodings.

The recorded suite also rejects every proper P01 prefix (1,045 cases) and every single-byte replacement by `X` (1,045 cases), then accepts the restored certificate. Its totals are generic accepts 10, C5-bound accepts 3, generic rejects 2,122 and C5-bound rejects 2,129. The suite exits normally with zero and empty stderr. The CLI accepts P01 and rejects the inspected arithmetic-only, square-goal and changed-witness controls with the documented ordinary exit values. An initial source-check attempt that could not resolve the imported kernel is preserved separately; successful checks and builds used isolated projects containing the required modules. That initial build-path failure is not counted as negative-proof detection.

The additive mutation contract was frozen separately without changing the original expectations. Its manifest hash is `4d3bb824f86c808e00d2e025a0c343e797f603cc2b72db802820b6feb2484d44`. Both applied diffs match their frozen patches, and the pre/post manifests verify.

| Actual source fault | Wrong-goal control | Build | Baseline P01 / wrong goal | Mutant P01 / wrong goal |
| --- | --- | ---: | --- | --- |
| Remove equation/fifth-power predicate | B06 square-refutation | 0 | 0 / 1 | 0 / 0 |
| Remove positivity predicate | B04 missing first positivity hypothesis | 0 | 0 / 1 | 0 / 0 |

All application stderr files are empty; the mutant wrong-goal outputs explicitly report C5-bound acceptance. These demonstrate erroneous statement labels caused by actual compiled source faults. They do not show the generic kernel accepting false mathematics: both wrong-goal fixtures have valid derivations of other statements. No crash, timeout, build failure or blanket rejection counts as a successful mutation outcome.

The separate-machine replay receipts match the original complete suite and P01 CLI stdout and exit values byte-for-byte, with empty stderr. The same suite and CLI ELF hashes were transferred; this is binary replay, not an independent compiler build. Its OOM-kill counter was 14 before and after. No cross-platform or universal compiler bit-identity claim follows.

## Reviewed identities

| Artifact | SHA-256 |
| --- | --- |
| K5 166-file `SHA256SUMS` manifest | `4ebc4f5b9fb7aae50cdd948be2d3dd29b2632a377509e351176b4f6746894c3e` |
| Original K5 `PREEXECUTION.sha256` | `37b16273c841198e04649060092666970988fba6245ae5bfcf9d1c8b0d8ccb44` |
| P01 certificate | `5cac88773a9ec4893b906342a6fa0037d3e404b25da6f8d7eedab4e58ca1e06a` |
| C5 binding source | `1c3e7324cefd9d27cd5497e901267837fa47722ee86209d3145f9ef55dfbdc77` |
| Inherited generic kernel source | `ca181abc7430c32c324d10653fba3cca47cbf9a2d2cea30a5c97ec0ac4e13128` |
| Historical qualified mathematical compiler | `a1444e4412efcf6eef4d2f0635ee530cacdc58414531b7c7b5bec6eff15d7ffa` |
| Original K5 suite ELF | `6ea17d9ac45a95c159bb161a7f0c4f12b9fab479f332528ffb7634da2453fd8e` |
| Original K5 CLI ELF | `3feb32223ac15ec3c488214515d12ceaac67ea535a53df1bffa19a4c7138db02` |
| Suite stdout, both recorded hosts | `e9593d49cd0c917c66a4c129a11be50ecdd01a44f5acd10591bfcb81f0bb7910` |
| P01 CLI stdout, both recorded hosts | `dc53a580214b54318fcf0435e1cc58dad5b0f03827081afb99140b7f622309ab` |
| M01 mutant ELF | `78df82c4bc22e149b0d89b686bca4cf3348c435a31b03d0fa0051a169ee21d8b` |
| M02 mutant ELF | `acd081d892434c41597187a880b468397b3bd0a2b388bb4b9e0a2023b177cf29` |

The complete K5 manifest and additive mutation manifest verified during this review. Later public-compiler rebuilds, if included, require their own receipts; the historical ELF identities above are not assertions about those later builds.

## Signing orchestration review

The reviewed Make recipe requires an explicitly pinned PQC verifier, both full hybrid public-key pins, signed evidence, strict-FP metadata and deterministic metadata. Bash `-eu -o pipefail` makes a nonzero cryptographic verifier exit fatal, even if its JSON contains internally valid signature fields. The recipe snapshots the MIC carrier, manifest and public-key files, then passes the same carrier bytes to cryptographic verification and the MIND binding checker. It computes the exact manifest-byte digest, requires MIND digest-binding acceptance, verifies every listed payload hash and only then prints `SIGNED_PAYLOAD=PASS`.

The unchanged MIND bridge checks the complete fixed 35-byte carrier body, exactly 13 uniquely ordered MAP fields, minimal bounded ULEB encodings, exact value types and lengths, both hybrid signature/public-key fields, the package-provenance scope, the expected 64-character digest and exact EOF. It does not perform cryptographic authentication. Its synthetic signature fixtures and two actual bypass mutations establish parsing/binding evidence only. The official compiler's cryptographic verifier is a separate explicit dependency.

The documentation correctly distinguishes the dedicated project identity from an established organization-wide trust root, requires public-key fingerprints from an independently trusted owner channel, excludes private keys from the package, explains manifest self-reference exclusions and states that provenance is not mathematical soundness or source-to-ELF equivalence. Verification assumes a fresh checkout without a concurrent writer. The final release signature and final manifest were not present when this contract was reviewed, so this review makes no claim that the final artifact's signatures or exhaustive payload list have passed. Those results require their own final-artifact receipts.

Reviewed signing contract identities:

- `Makefile`: `44e91bcc82dbb0cc959118800e623475265bfab68e6dd015ebb3f084000def17`.
- `signing/README.md`: `a3f15b2f94a1dab77f9c2772b3d8d76b284b14e397a33d585a44d3eecd42aa73`.
- `signing/map-binding/src/bridge.mind`: `a6fa375827cca00fbfe0d79e06c2a0c09b37efad4e9fe59c5aca0450cbcbfe0a`.

## Remaining acceptance boundary

Finite tests, actual mutations, receipt integrity and separate-machine replay support this implementation review. They do not establish a universally sound implementation, a verified compiler, mathematical novelty or minimality of the known witness, or progress on RH. `FORMAL_PROOF_SUBMITTED` and `FORMAL_ACCEPTANCE=BLOCKED` remain appropriate pending the repository's designated independent soundness and trusted-computing-base validation requirements. No proof-status promotion is authorized by this report.
