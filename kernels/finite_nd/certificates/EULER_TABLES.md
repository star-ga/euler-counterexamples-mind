# Euler C4 certificate tables

Author: STARGA Inc.

The exact reviewed fixture is P01_euler_c4_refutation.nd.txt. Negation means implication to Bottom. Variables are de Bruijn indices: within the original four nested quantifiers v3=a, v2=b, v1=c, v0=d. All four quantifiers range over Z, even though computed ground numerals are nonnegative. The antecedent is ((a>0 and b>0) and (c>0 and d>0)); the equality is ((a^4+b^4)+c^4)=d^4, with each x^4=(x*x)*(x*x).

C4 is F15; final declared goal is F46 = Imp(F15,Bottom), namely not C4. The four instantiated bodies are F24, F32, F39, F45. The benchmark fixture is immutable and hash recorded; a generic CLI accepts caller-declared goals and must not label arbitrary accepted inputs as Euler refutations.

## Terms

| Index | Record | Meaning |
|---|---|---|
| T1 | 2,3,0 | v3 |
| T2 | 2,2,0 | v2 |
| T3 | 2,1,0 | v1 |
| T4 | 2,0,0 | v0 |
| T5 | 4,1,1 | mul(T1,T1) |
| T6 | 4,5,5 | mul(T5,T5) |
| T7 | 4,2,2 | mul(T2,T2) |
| T8 | 4,7,7 | mul(T7,T7) |
| T9 | 4,3,3 | mul(T3,T3) |
| T10 | 4,9,9 | mul(T9,T9) |
| T11 | 4,4,4 | mul(T4,T4) |
| T12 | 4,11,11 | mul(T11,T11) |
| T13 | 3,6,8 | add(T6,T8) |
| T14 | 3,13,10 | add(T13,T10) |
| T15 | 1,95800,0 | 95800 |
| T16 | 1,217519,0 | 217519 |
| T17 | 1,414560,0 | 414560 |
| T18 | 1,422481,0 | 422481 |
| T19 | 4,15,15 | mul(T15,T15) |
| T20 | 4,19,19 | mul(T19,T19) |
| T21 | 3,20,8 | add(T20,T8) |
| T22 | 3,21,10 | add(T21,T10) |
| T23 | 4,16,16 | mul(T16,T16) |
| T24 | 4,23,23 | mul(T23,T23) |
| T25 | 3,20,24 | add(T20,T24) |
| T26 | 3,25,10 | add(T25,T10) |
| T27 | 4,17,17 | mul(T17,T17) |
| T28 | 4,27,27 | mul(T27,T27) |
| T29 | 3,25,28 | add(T25,T28) |
| T30 | 4,18,18 | mul(T18,T18) |
| T31 | 4,30,30 | mul(T30,T30) |

## Formulas

| Index | Record | Meaning |
|---|---|---|
| F1 | 1,1,0 | GT0(T1) |
| F2 | 1,2,0 | GT0(T2) |
| F3 | 1,3,0 | GT0(T3) |
| F4 | 1,4,0 | GT0(T4) |
| F5 | 4,1,2 | And(F1,F2) |
| F6 | 4,3,4 | And(F3,F4) |
| F7 | 4,5,6 | And(F5,F6) |
| F8 | 2,14,12 | Eq(T14,T12) |
| F9 | 3,0,0 | Bottom |
| F10 | 5,8,9 | Imp(F8,F9) |
| F11 | 5,7,10 | Imp(F7,F10) |
| F12 | 6,11,0 | ForallZ(F11) |
| F13 | 6,12,0 | ForallZ(F12) |
| F14 | 6,13,0 | ForallZ(F13) |
| F15 | 6,14,0 | ForallZ(F14) |
| F16 | 1,15,0 | GT0(T15) |
| F17 | 4,16,2 | And(F16,F2) |
| F18 | 4,17,6 | And(F17,F6) |
| F19 | 2,22,12 | Eq(T22,T12) |
| F20 | 5,19,9 | Imp(F19,F9) |
| F21 | 5,18,20 | Imp(F18,F20) |
| F22 | 6,21,0 | ForallZ(F21) |
| F23 | 6,22,0 | ForallZ(F22) |
| F24 | 6,23,0 | ForallZ(F23) |
| F25 | 1,16,0 | GT0(T16) |
| F26 | 4,16,25 | And(F16,F25) |
| F27 | 4,26,6 | And(F26,F6) |
| F28 | 2,26,12 | Eq(T26,T12) |
| F29 | 5,28,9 | Imp(F28,F9) |
| F30 | 5,27,29 | Imp(F27,F29) |
| F31 | 6,30,0 | ForallZ(F30) |
| F32 | 6,31,0 | ForallZ(F31) |
| F33 | 1,17,0 | GT0(T17) |
| F34 | 4,33,4 | And(F33,F4) |
| F35 | 4,26,34 | And(F26,F34) |
| F36 | 2,29,12 | Eq(T29,T12) |
| F37 | 5,36,9 | Imp(F36,F9) |
| F38 | 5,35,37 | Imp(F35,F37) |
| F39 | 6,38,0 | ForallZ(F38) |
| F40 | 1,18,0 | GT0(T18) |
| F41 | 4,33,40 | And(F33,F40) |
| F42 | 4,26,41 | And(F26,F41) |
| F43 | 2,29,31 | Eq(T29,T31) |
| F44 | 5,43,9 | Imp(F43,F9) |
| F45 | 5,42,44 | Imp(F42,F44) |
| F46 | 5,15,9 | Imp(F15,F9) |

## Proof

| Line | Rule | Result | p1 | p2 | aux term |
|---|---|---|---|---|---|
| 1 | ASSUME | F15 | 0 | 0 | 0 |
| 2 | FORALL_ELIM | F24 | 1 | 0 | 15 |
| 3 | FORALL_ELIM | F32 | 2 | 0 | 16 |
| 4 | FORALL_ELIM | F39 | 3 | 0 | 17 |
| 5 | FORALL_ELIM | F45 | 4 | 0 | 18 |
| 6 | GROUND_POS | F16 | 0 | 0 | 0 |
| 7 | GROUND_POS | F25 | 0 | 0 | 0 |
| 8 | GROUND_POS | F33 | 0 | 0 | 0 |
| 9 | GROUND_POS | F40 | 0 | 0 | 0 |
| 10 | AND_INTRO | F26 | 6 | 7 | 0 |
| 11 | AND_INTRO | F41 | 8 | 9 | 0 |
| 12 | AND_INTRO | F42 | 10 | 11 | 0 |
| 13 | GROUND_EQ | F43 | 0 | 0 | 0 |
| 14 | IMP_ELIM | F44 | 5 | 12 | 0 |
| 15 | IMP_ELIM | F9 | 14 | 13 | 0 |
| 16 | NEG_INTRO | F46 | 1 | 15 | 0 |
