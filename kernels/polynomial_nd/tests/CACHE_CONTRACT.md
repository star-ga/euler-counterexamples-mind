# Source-informed cache test supplement

Author: STARGA Inc.

This supplement was written after source review, before executing these extra
tests. It is separate from the independently predeclared 54-fixture suite.

1. Check P01 once; expect acceptance and record its remaining polynomial budget.
2. Change only P01's proof count to 2 and append an identical POLY_ID proof line.
   Expect acceptance. Its remaining budget must equal the one-line budget minus
   exactly 3 (the binomial normal form has three nonzero monomials). This checks
   cache reuse without either renormalization or work-budget reset.
3. In one certificate, first prove forall x, x=x, then claim forall x, x=x+1.
   Expect rejection even though normalization has already completed. A completed
   cache cannot substitute for checking each rule's actual equality.

Expected: two accepts, one reject. A white-box budget check supports cache
behavior only; no theorem-acceptance status changes.
