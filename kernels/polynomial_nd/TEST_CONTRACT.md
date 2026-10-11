# Polynomial extension: pre-execution adversarial contract

Author: STARGA Inc.

This plan was fixed before its author inspected the new checker implementation
or executed it. Expected outcomes follow the version-2 rule specification and
integer algebra, not observed checker answers. A SHA-256 receipt in
`tests/PREEXECUTION_PLAN.sha256` freezes this file. Later corrections must have
separate explanation and preserve this original contract.

The only new inference is rule 10, with `p1=p2=aux=0`, for a closed
`Forall^k(Eq(L,R))`, `1 <= k <= 4`. Every declared term is normalized, including
unused terms. Exponents per variable are at most 32, variables are indices 0–3,
coefficients are less than 10^36, and every term has at most 128 nonzero
monomials. The total polynomial work budget is 2,000,000. Exhaustion is a normal
rejection, never success, signal, timeout, or silent wraparound. Legacy version
1 rules and its 65536-byte API contract remain strict; the polynomial API uses
at least 4194304 workspace bytes.

## Fixed certificate cases

All P cases expect 1; all N cases expect 0. All quantifiers range over Z.
Actual encoded ASTs, rather than a friendly name, determine the stated goal.

| ID | Required case and mathematical/structural reason |
| --- | --- |
| P01 | Binomial: forall n, (n+1)^2 = n^2+(2n+1). |
| P02 | Scaled K4: forall n, (95800n)^4+(217519n)^4+(414560n)^4=(422481n)^4. |
| P03 | Addition commutativity in two variables. |
| P04 | Multiplication commutativity in two variables. |
| P05 | Three-variable distributivity x(y+z)=xy+xz. |
| P06 | Four-variable product reordering (xy)(zw)=(wz)(yx). |
| P07 | Zero polynomial n*0=0, including removal of zero monomials. |
| P08 | Vacuous quantification forall n, 1+1=2. |
| P09 | Repeated monomial collection n+n=2n. |
| P10 | Exponent boundary n^32=n^32, constructed at shallow AST depth. |
| P11 | Large exact coefficient carry: (999999n+1)^2 expanded. |
| P12 | Instantiate P01 at closed numeral 3, preserving exact AST structure. |
| P13 | Nested instantiation: forall x,y, x+y=y+x; substitute x=2, leave y bound. |
| P14 | Instantiate P13's remaining binder at 3. |
| P15 | POLY_ID inside an active contradiction scope; use it only there and discharge. |
| P16 | Exactly 128 monomials: (1+x+...+x^7)(1+y+...+y^15), reflexivity. |
| N01 | P01 forged coefficient 3 instead of 2; false at n=1. |
| N02 | P01 wrong final constant 2 instead of 1; false at n=0. |
| N03 | forall x,y, x=y; mismatched variables, false at x=0,y=1. |
| N04 | One binder with index 1; unbound variable. |
| N05 | Open Eq(n,n+1) directly under POLY_ID; closedness and shape violation. |
| N06 | Open Eq(n,n+1) under GROUND_EQ; zero-filled ground buffers are not proof. |
| N07 | Five universal wrappers around a closed identity; shape cap. |
| N08 | POLY_ID nonzero p1. |
| N09 | POLY_ID nonzero p2. |
| N10 | POLY_ID nonzero aux. |
| N11 | POLY_ID in version 1. |
| N12 | Valid polynomial proof with a different declared closed goal. |
| N13 | forall n, n>0 via POLY_ID; unsupported positivity shape and false statement. |
| N14 | forall n, (n=n -> n=n) via POLY_ID; implication shape unsupported. |
| N15 | forall n, (n=n and n=n) via POLY_ID; conjunction shape unsupported. |
| N16 | Closed unquantified Eq(1,1) via POLY_ID; requires at least one binder. |
| N17 | Symbolic coefficient overflow: (999999n)^8=(999999n)^8; true but out of budget. |
| N18 | Unused symbolic coefficient overflow must still reject an unrelated valid goal. |
| N19 | n^33=n^33; true but exponent cap exceeded at shallow AST depth. |
| N20 | Unused variable index 4 rejects even an unrelated vacuous identity. |
| N21 | 129 monomials: P16's product plus x^8; true reflexivity but monomial cap exceeded. |
| N22 | Repeated legal-size 128-by-128 polynomial products exhaust the global work budget. |
| N23 | Trailing canonical number after a valid P01 certificate. |
| N24 | Trailing LF after a valid P01 certificate. |
| N25 | Missing final LF. |
| N26 | Wrong magic. |
| N27 | Unknown version 3. |
| N28 | Reuse assumption-independent POLY_ID line after its creation scope was popped. |
| N29 | Leave an unrelated assumption open before final valid POLY_ID line. |
| N30 | Nested instantiation substitutes the inner variable instead of the outer variable. |
| N31 | Instantiation uses an open witness term. |
| N32 | Instantiation claims the structurally wrong witness (3 when aux is 2). |
| N33 | Scaled K4 first coefficient changed from 95800 to 95801. |
| N34 | Unknown rule 11. |
| N35 | Reserved term field nonzero. |
| N36 | Reserved universal formula field nonzero. |

The harness additionally exercises six numeric API refusals using valid backing
allocations: insufficient workspace, oversized input, null input, unaligned
workspace, overlapping input/workspace, and negative input size. Every proper
prefix of P01 and every one-byte replacement by nondecimal X must reject. A
restored P01 must accept after these mutations. Input bytes must remain unchanged
on normal full-certificate checks, and workspace guard bytes must remain intact.

Legacy controls run the unchanged version-1 fixture corpus through
`finite_nd_check`, retaining its 8 accepts and 49 rejects. It must reject every
new version-2 positive certificate. A version-1 rule-10 certificate must also
reject. These controls do not reinterpret older fixtures as version 2.

## Prelisted source mutations

Mutation execution is separately owned by the integrator. Each mutant must first
accept its named positive control. The named negative must change from ordinary
0 to ordinary 1; compile failure, crash, or timeout is not a killed mutant.

| ID | Deliberate defect | Positive control | Distinguishing negative |
| --- | --- | --- | --- |
| M01 | Bypass equality of normalized coefficients. | P01 | N01 |
| M02 | Ignore monomial variable/exponent identity during equality. | P03 | N03 |
| M03 | Remove closedness/allowed-binder checks for POLY_ID. | P01 | N04 |
| M04 | Ignore POLY_ID unused-field restrictions. | P01 | N10 |
| M05 | Ignore coefficient carry/upper-limb overflow. | P01 | N17 |
| M06 | Disable exponent-cap refusal. | P10 | N19 |
| M07 | Disable complete-input-consumption check. | P01 | N23 |
| M08 | Ignore proof creation-context availability. | P15 | N28 |
| M09 | Substitute at the wrong de Bruijn binder depth. | P08 | N30 |
| M10 | Ignore the final formula/declared-goal match. | P01 | N12 |
| M11 | Disable monomial-cap refusal. | P16 | N21 |
| M12 | Disable polynomial work-budget refusal. | P01 | N22 |

## Execution and claim boundary

All certificate generation and test decisions are committed MIND. Shell may
stage exact sources, invoke the pinned native compiler, hash artifacts, and
capture exit/stdout/stderr/resource receipts. One CPU and at most 2 GiB address
space are permitted; no other processes are modified. Retain raw failures and
report actual counts. Candidate checks do not upgrade theorem status:
`FORMAL_PROOF_SUBMITTED`; `FORMAL_ACCEPTANCE=BLOCKED`.
