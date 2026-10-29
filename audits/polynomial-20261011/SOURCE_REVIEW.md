# Independent source-level soundness review of NDv2

Author: STARGA Inc.

Date: 2026-10-11. Method: independent model-assisted mathematical and implementation review. This is not human review, designated-verifier approval, a machine-checked metatheorem, or a formal acceptance decision.

Repository examined read-only: `/PUBLIC_REPO`.

Pinned Git commit: `cacb9492a0c356dd094d08972910fda9232b4472`.

**Disposition:** no concrete soundness counterexample was found in the inspected source. The source supports the conditional mathematical argument below. Failure to find a bug is not proof that no bug exists. `FORMAL_PROOF_SUBMITTED` is preserved; `NATIVE_VERIFIED` is not enabled; direct-native qualification remains `BLOCKED`. This report cannot change those statuses.

## Scope, independence, and exact identity

I read all 580 lines of `kernels/polynomial_nd/src/kernel.mind`, its CLI, the syntax/foundations documents, `PROOF_POLICY.md`, and `AUTHORSHIP.md`. I reconstructed the arithmetic, normalization, substitution, and dependency arguments directly from source before comparing the extension's original `SOUNDNESS.md`. I did not read or rely on the positive implementation-review reports, recorded positive test outcomes, mutation outcomes, or another agent's conclusion as soundness evidence.

No repository file was edited, no compiler build was started, and no commit, signature, publication, or approval was made. This report's executable diagnostics were limited to source identification and exact arithmetic constants; they are not substitute proof checking. No freshly executed native checker result is claimed by this report. A separate adversarial review may supply execution evidence, with its own scope and identity.

All source locations below refer to the exact commit above. `K:L` means `kernels/polynomial_nd/src/kernel.mind` line L; `C:L` means `kernels/polynomial_nd/src/main.mind` line L. Ranges are inclusive. The following SHA-256 values identify the reviewed bytes:

| File | SHA-256 |
| --- | --- |
| `kernels/polynomial_nd/src/kernel.mind` | `7eed71f7cb06715744471edf80da5b6b1f3cdadb2ba345e3605814d2951fa3e2` |
| `kernels/polynomial_nd/src/main.mind` | `3e02a65cb9db29ca9b4610e29259ee6636b1bf5c47921568e8f4d9382ebc36a2` |
| `PROOF_POLICY.md` | `02c95b28529c02c4f011992aee483a5aacef41039e27b11a033859fda0820b0c` |
| `AUTHORSHIP.md` | `9855992201d1bf9c6cc3002cd1ee1fbb1ecc0a778b01736762f5a2e22880677c` |
| `kernels/polynomial_nd/SYNTAX.md` | `5dfc8f755ab1efead2dcc274fec39d88e213a7c74fa97b58c6ab730190439866` |
| `kernels/polynomial_nd/FOUNDATIONS.md` | `bfefcb85dce9b6f3418c11ef254a96f75018ba39e56611a5ac5ca78bd51dbf60` |
| `kernels/polynomial_nd/SOUNDNESS.md` | `d14308c81524bf98913f7e45f9984ef9325963a1da1b5f53113396beb33cb9e0` |
| `kernels/polynomial_nd/certificates/P02_scaled_k4.nd.txt` | `cb48461b46ebde6796993c45109f5e46bd2c30e71f063794a54b9d1259dd01a1` |


## Conditions of the conclusion

The argument is about the specified, ordinary execution of the inspected source. It assumes correct in-range signed integer operations, control flow, recursion, load/store intrinsics, the compiler/backend/runtime, OS/ABI, and hardware. It also assumes the documented API caller owns immutable readable input and exclusive writable workspace of the required extent, with valid lifetimes and no concurrent mutation. These are explicit trust conditions, not conclusions established by numeric pointer checks.

`PROOF_POLICY.md:5-24` distinguishes candidate acceptance from kernel soundness approval, requires exact artifact/dependency binding, and states that source/compiler/runtime correctness is not supplied by a machine-checked metatheorem. `FOUNDATIONS.md:12-18,42-45` repeats that limitation. This review supplies substantive source reasoning, but it is not the owner/designated-verifier decision required by `PROOF_POLICY.md:9-17`.

## Parsing and initialized-source invariants

`nd_number` accepts only nonempty canonical unsigned decimal fields followed by LF (`K:19-44`). Leading zeroes and non-digits fail; the pre-multiplication limit of 99999 bounds every returned field by 999999. Parser failure is recorded and checked before parsed term/formula/proof fields are used (`K:280,319,437`). A sixth digit can reach 999999, but a seventh digit is refused before multiplication. There is no signed literal or integer-wrap parsing route.

Term count, formula count, and proof count are bounded respectively by 256, 512, and 256 (`K:549-561`). Every binary term child is positive and strictly earlier (`K:295`); formula constructors refer only to earlier formula nodes (`K:338,346`), and atomic terms are range-checked (`K:325,330`). Tags and reserved fields are checked (`K:285-305,324-350`). These establish finite acyclic declarations with initialized children.

The computed `need` metadata is exact binder demand: numeral 0; variable index plus one; binary maximum; universal predecessor truncated at 0 (`K:284-309,323-354`). This follows by structural induction independently of term values. Proof results and the declared goal must have demand zero (`K:440,559`). Thus a variable cannot be treated as a closed ground value merely because its unevaluated value buffer happens to contain zero. Ground rules separately check their operands' demand (`K:460,465`).

Every declared ground term is evaluated during parsing (`K:300-305`), including unused terms. Any ground overflow therefore stops parsing before later proof rules. Symbolic normalization likewise visits every term when first requested (`K:213-241`). Unsupported unused terms can cause conservative rejection; they cannot supply an unchecked fact.

## Exact coefficient and ground arithmetic

Let B = 1000 and let a 12-limb vector denote `sum(a[i] * B^i, i=0..11)`. The representation invariant is `0 <= a[i] <= 999`; hence its value lies in `[0, 10^36)`.

**Numerals.** `K:283,288-289` clears all twelve limbs then places `a % 1000` and `a / 1000` in the first two. The parser bound makes both digits valid, and their radix value is exactly the numeral.

**Addition.** `K:51-64` checks both digits and the carry before calculating `v`. The largest intermediate is `999 + 999 + 1 = 1999`. The identity `v = (v % B) + B*(v / B)` maintains the usual prefix-sum invariant. After all twelve digits, a nonzero carry means the exact sum is at least `B^12`, so rejection at `K:63` is necessary. Success gives the exact sum with no discarded high limb. If output equals the first input, iteration i reads that limb before overwriting it, and all future limbs are untouched. This is the alias used for coefficient merging at `K:148-150`; no overlapping shifted-digit alias is used.

**Multiplication.** `K:65-98` clears a separate 24-limb temporary and adds one schoolbook row at a time. At each inner iteration, the old temporary digit, input digits, and carry are individually checked. The largest intermediate is `999*999 + 999 + 999 = 999999`, far below signed-i64 overflow. Taking remainder and quotient by B preserves each row's exact weighted value.

After row i's twelve inner iterations, its final carry belongs at index `i+12`. Earlier row r < i touched at most index `r+12 <= i+11`, so that position is still zero. The source also explicitly checks this fact (`K:82-85`). Thus the temporary after twelve rows represents the exact product, which is less than `B^24`. The upper twelve limbs must all be zero before the lower twelve are copied to output (`K:87-96`). Overflow cannot silently become an accepted modular product. Output is not written until those checks pass.

**Failure propagation.** A failed addition may leave partial output; failed normalization may leave partly shifted cache records. Every relevant caller immediately returns failure (`K:150,184,201-202,221-235,269,447`). `nd_read_proof` failure reaches API refusal at `K:562`. There is no success path that resumes from the partly computed result. New API calls clear the validity marker and rebuild required entries.

`nd_positive` and `nd_values_equal` themselves do not revalidate digits (`K:99-114`). That is safe only under the initialized-arithmetic invariant proved above. Their calls reachable through the public API satisfy that invariant; they are not standalone validators for attacker-supplied limb arrays. This is a useful review boundary, not a confirmed vulnerability.

## Base-33 keys and exponent collision

Define `E(e) = e0 + 33*e1 + 33^2*e2 + 33^3*e3`, with each digit in `[0,32]`. Uniqueness follows by repeatedly taking remainder and quotient by 33. Its maximum is `33^4 - 1 = 1,185,920`; insertion checks the half-open key range `[0,1,185,921)` at `K:139`.

Variable index j, restricted to 0..3, becomes key `33^j` (`K:224-228`). `poly_key_product` extracts the two keys' four digits separately, rejects any digit sum greater than 32 *before adding it to the packed key*, and then checks that no higher digits remain (`K:166-176`). The calculation never needs a key above the checked maximum; even the final place multiplier is only `33^4`.

The tempting counterexample is `X0^33 = X1`, because an unchecked packed-key sum would map exponent 33 in digit 0 to key 33. The source blocks the critical multiplication when the digit sum reaches 33 (`K:170-171`); it never inserts that carried key. Distinct exponent vectors in the supported domain therefore do not collide by radix carry. This is a precise source refutation of that attack, not a native test result.

There is no exponentiation constructor to audit: parsing admits only numerals, variables, addition, multiplication (`K:285-305`). A power is a product DAG. Exponent overflow is assessed on its monomial factors; an empty zero polynomial has no monomial whose exponent can overflow. A separately declared unsupported nonzero power still fails when its own entry is normalized, even if a later node multiplies it by zero.

## Independent normalization argument over all integer assignments

Fix an **arbitrary** `rho = (rho0,rho1,rho2,rho3)` in `Z^4`, without any magnitude or sign bound. For exponent vector e define `M_e(rho) = product(rhoj^ej, j=0..3)`. Exponent 0 contributes 1, also when its base is zero. For a stored polynomial define its meaning as the finite sum of exact coefficient times monomial. The empty list means 0. These are mathematical integer operations; the checker does not evaluate rho in its limb buffers.

The cache invariant after successful construction is: count is 0..128; live records have strictly increasing distinct valid keys; each coefficient is a valid strictly positive 12-limb integer; all live record bytes are initialized. I checked preservation as follows.

1. **Insertion (`K:137-165`).** Zero coefficients return without modification. For a nonzero coefficient, the scan finds an equal key or the first larger key. Equality invokes checked exact addition; positive coefficients cannot cancel. A new record is inserted only below capacity. The descending shift preserves order and every old record, after which key and all twelve coefficient limbs are written before count is increased. Successful insertion adds exactly the indicated monomial to the old interpretation.
2. **Merge (`K:178-188`).** Iterating each initialized source record and inserting it adds exactly the source polynomial to the output polynomial. The source and destination are disjoint for every normalization call.
3. **Product (`K:189-208`).** Every ordered pair of source records is visited exactly once. Digitwise key addition computes exponent-vector addition, checked multiplication computes the coefficient product, and insertion accumulates equal keys. Distributivity in Z and `rhoj^a * rhoj^b = rhoj^(a+b)` give exactly the product of the two source interpretations. Those laws hold for negative, zero, and positive bases. Failure on degree, coefficient, capacity, or work bounds aborts instead of approximating this operation.
4. **Topological term induction (`K:209-242`).** Each output starts empty. Numeral normalization inserts its exact ground constant; zero therefore stays empty. A variable inserts coefficient 1 at its unit exponent key. Addition merges its two earlier children; multiplication uses the earlier children's product. The parsing invariant ensures these children were already completed. Hence, whenever the full pass succeeds, each term's normal form has precisely its AST interpretation for this arbitrary rho.
5. **Comparison and universal closure (`K:243-270`).** Equal record counts, keys, and all coefficient limbs imply identical polynomial interpretations for every rho. Combining that fact with step 4 gives equality of the two actual body ASTs for every integer assignment. `poly_rule` accepts only one through four enclosing universal binders around an equality, and checks binder demand against their count. The proof interpreter also checks closure. Map the innermost binder to rho0, the next to rho1, and so on; each assignment to the k bound variables extends to a rho in `Z^4`. Unused remaining coordinates do not occur. Therefore the nested universal statement is true, including vacuous binders.

Only the forward implication from equal normal forms to equal integer denotations is needed. The review does not assume a complete decision procedure for every true arithmetic formula, injectivity of polynomial evaluation at a sampled point, or any finite enumeration of integer assignments. Natural coefficients do not restrict variables to natural values. The coefficient bound limits stored symbolic constants, not the value attained after substituting an arbitrary integer.

Zero cases follow from this construction: numeral zero inserts no record; merge with empty adds zero; a product with an empty factor has no record pairs and remains empty; exponent-zero factors have value 1 at zero. There is no appeal to dividing by variables and no nonzero-variable side condition. Repeated source pointers, as in `t*t`, are permitted because only the distinct output is modified.

## Workspace, aliasing, and cache lifecycle

I recomputed the half-open byte ranges from `K:9-12,66,122-123,192,227,454`:

| Range from workspace base | Contents |
| --- | --- |
| `[0,128)` | Header |
| `[128,10368)` | 256 terms, 40 bytes each |
| `[10368,30848)` | 512 formulas, 40 bytes each |
| `[30848,55424)` | 256 ground values, 96 bytes each |
| `[55424,63616)` | 256 proof records, 32 bytes each |
| `[63616,63856)` | 30 assumption-stack entries |
| `[63856,64048)` | 24 arithmetic temporary limbs |
| `[64048,65536)` | Reserved cleared bytes |
| `[65536,3475456)` | 256 polynomial entries, 13,320 bytes each |
| `[3475456,3475552)` | 12-limb coefficient temporary |
| `[3475552,4194304)` | Unused tail |

The regions are disjoint and fit the v2 requirement. All base/record strides used for i64 data are multiples of eight. Counts are checked before capacity-sensitive indexing. At the largest insertion, new record index 127 fits exactly within its entry; insertion into a count-128 list can merge an existing key but refuses a new one before shifting (`K:155`).

Topological children are strictly earlier, so an output cache entry never aliases either input. Source children may alias each other safely because the product only reads them. The product's coefficient temporary is separate from both the cache and the arithmetic temporary. Record shifts copy adjacent, disjoint 104-byte records in descending index order. Ground arithmetic inputs are earlier value records and its output is a new record. No call passes the arithmetic temporary as an arithmetic operand.

Only the first 65,536 bytes are zeroed at API entry (`K:543`). This clears the marker at offset 104, so residual cache bytes from an earlier successful certificate are not trusted. The normalizer initializes each node's count to zero before any access through that node (`K:219`). Each new record is fully written before its count becomes visible (`K:163-164`); completed child nodes were initialized on the same pass. The complete marker is set only after the last term succeeds (`K:241`). All later uses of `poly_equal` come after successful `poly_normalize` (`K:269-270`). Terms cannot be changed by later proof records because their workspace regions are disjoint and input bytes are immutable by contract.

The numeric API guards check positive pointers, bounded input length, sufficient capacity, alignment, signed-address addition bounds, and nonoverlap (`K:539-542`) before initialization. Every used offset is below the validated extent. These guards do **not** prove allocation ownership, mapping permissions, exclusivity, or absence of concurrent writes; those remain caller obligations stated at `K:531-534`. An attack that corrupts workspace externally is outside this API's soundness theorem.

## Substitution, binder scope, and logical dependency discharge

The sequent invariant I used is: every accepted proof line's closed formula follows in the integer model from the formulas at its recorded assumption-occurrence bits; those dependency bits are active when the line is produced. Creation context additionally restricts future reuse. This is stronger operational scoping than semantic dependency tracking alone.

**Structural comparison.** `nd_same` uses recursive structural comparison (`K:368-416`), not normal-form equivalence and not a node-index shortcut. All recursively visited children are valid AST references from parsing. Formula tag must match; terms and reserved fields have already been validated. Recursion/work exhaustion returns false (`K:362-366`) and cannot turn a failed comparison into equality.

**Closed substitution.** Rule 8 requires a universal premise and a closed witness term (`K:479-484`). At nested binder depth d, a variable of index d is replaced by the whole closed witness through a non-substituting structural comparison; indices above d decrease by one; indices below d remain unchanged (`K:374-385`). Entering another universal increments d (`K:408-409`). This is exactly removal of one de Bruijn binder. The closed witness contains no variables and thus needs no shift when moved under other binders. Substitution is applied at every occurrence; the checker never accepts an independently supplied substitution receipt. Result closure is checked globally. This establishes the usual substitution lemma under the intended integer semantics.

**Fresh assumptions.** Rule 1 allocates `1 << id` with monotonically increasing `id < 30`; it records the occurrence on a bounded stack and activates its bit (`K:449-456`). IDs never decrease or recycle. Equal formula text cannot make two occurrences the same assumption. All masks fit below `2^30`; shifts and mask arithmetic are within signed-i64 range.

**Premise availability.** Every premise must have an earlier positive line index and both its dependency mask and creation-context mask included in the current active mask (`K:417-426,472,492`). Therefore a proof generated inside a scope cannot be revived after that scope closes, even if its actual dependency set is empty. A later assumption with identical text cannot reactivate the old occurrence because bits are fresh.

**Rules 2 and 3.** Ground positivity and equality are justified by the exact nonnegative ground evaluator and explicit closed-operand checks (`K:458-467`). Every nonzero valid digit vector denotes a positive integer. Open term buffers cannot be used here.

**Rules 4–7.** Conjunction introduction combines checked matching premises and unions their dependencies; conjunction eliminations retain dependencies and compare the selected child; implication elimination matches antecedent and consequent and unions both premise dependencies (`K:485-503`). These operations preserve the stated sequent invariant.

**Rule 8.** Universal elimination retains its premise dependencies and uses the substitution lemma above. Restricting witnesses to closed nonnegative syntax reduces what can be instantiated, without changing the universal premise's range over all Z.

**Rule 9.** Both premises are checked before scope mutation (`K:472,492,505-518`). Premise 1 must be the actual current top assumption line, with a nonzero own-bit. Premise 2 must prove Bottom. The claimed result must be implication from the exact assumption formula to Bottom. The result's dependency set is the contradiction's set minus only that assumption bit (`K:515-516`); active mask and stack pop exactly the same occurrence (`K:517-518`). Its creation context is stored after the pop (`K:525`). Semantically, if the other dependencies hold, assuming this discharged formula yields falsehood, so its negation follows. If the contradiction does not use this assumption, vacuous discharge is still sound; it does not drop any other dependency.

**Rule 10.** `POLY_ID` is justified by the independent normalization argument, receives no assumption dependency, and still records its creation context. It cannot assert Bottom, an implication, or a positivity atom because its formula shape is checked before normalization (`K:257-270,443-447`). All unused rule fields are required to be zero (`K:445`), and unknown rules are rejected (`K:471`).

Finally the API requires successful full parsing, exact EOF, empty active mask and stack, zero final dependencies, and structural equality of the final formula with the declared closed goal (`K:562-570`). The final accepted sequent therefore has no assumptions. Under the stated execution/semantic conditions, its conclusion is true in the intended integer model.

## Counterexample attempts and limitations

The following were source-level falsification attempts, not reported executions:

| Attempt | Why the inspected source blocks it |
| --- | --- |
| Carry `X0^33` into key for `X1` | Independent digit sum rejected at `K:170-171` |
| Use low limbs of an overflowing coefficient | Addition carry and product upper limbs checked at `K:63,87-96`; failure propagates |
| Exploit zeroed open-term buffers as ground facts | Closure/need checks at `K:440,460,465` |
| Reuse forged/stale v2 cache bytes | Marker reset at `K:543`; count initialization at `K:219`; complete marker set only at `K:241` |
| Shift a full cache beyond its entry | New-key insertion refuses before shift at `K:155` |
| Overwrite input during parsing | Numeric overlap refusal at `K:542`, plus caller-memory contract |
| Substitute a captured/open witness | Witness demand must be zero at `K:482`; binder-aware traversal at `K:374-385,408-409` |
| Reuse a discharged line or recycle assumption bit | Context/dependency subset checks at `K:424-425`; monotonic IDs at `K:449-456` |
| Discharge a different equal-text assumption | Exact top proof-line reference required at `K:508`, not only formula text |
| Accept unchecked fields, extra input, or wrong goal | Field checks, exact EOF, final structural matching at `K:445,478,486,492,565,569` |

I found no confirmed false-acceptance certificate or source contradiction. Consequently this report contains no claimed native counterexample reproduction. It does not establish exhaustive adversarial coverage or compiler correctness. In particular, helper invariants rely on their actual call graph; exposing internal helpers as unguarded public APIs or allowing concurrent workspace mutation would require a different audit.

Resource exhaustion can reject correct identities. Limits include symbolic coefficient magnitude, monomial count, degree, AST depth, structural work, and polynomial work. Successful normalization of a huge-integer assignment is not required because assignments are not enumerated; the symbolic denotation proof covers them. Conversely, a true `0 * huge_ground_term = 0` can be rejected if the declared child overflows while parsing. This is deliberate incompleteness, not an unsound arithmetic simplification.

The scaled K4 certificate was also manually decoded: its terms at lines 4-60 build the four coefficient-times-variable terms, square each twice, and add the first three; formula records at lines 62-67 assert their equality under one universal; its sole proof instruction at lines 70-74 is rule 10. Exact arithmetic diagnostic calculation gives both fourth-power coefficients as `31858749840007945920321`. This connects the source-level statement to the displayed scaled identity; it does not establish positivity at nonpositive scalings or infinitely many distinct primitive tuples. The latter claims are not justified by this equality.

## Remaining acceptance obligations

Before any formal status change, an owner/designated verifier still needs to assess the exact theorem/certificate binding, this calculus and its assumptions, the source-to-executable relationship, complete execution dependency closure, independently obtained execution evidence, and the limitations of the prose metatheory. This review does not independently qualify the direct native backend or validate every shipped binary against source. It neither signs the artifact nor accepts another agent's agreement as mathematical approval.

**Final review state:** independent source analysis completed; no confirmed soundness defect found; no formal approval granted. `FORMAL_PROOF_SUBMITTED` and direct-native `BLOCKED` remain unchanged.
