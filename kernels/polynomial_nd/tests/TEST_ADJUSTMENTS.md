# Pre-execution amendments

Author: STARGA Inc.

The original TEST_CONTRACT.md remains unchanged with its original hash.
These amendments were made before executing the new checker or inspecting its
source. They change no mathematical expected outcome.

1. N22's original phrase "128-by-128 polynomial products" cannot isolate the
   work budget: in the unsigned coefficient fragment, multiplying two nonzero
   128-support polynomials has at least 255 monomials. The implemented N22
   instead declares 200 independent additions of the same 128-monomial
   polynomial to itself. It has 248 terms, degree (7,15), depth at most 18, and
   coefficient 2 in each added result. The specified insertion-work accounting
   exhausts 2,000,000 units while other limits remain satisfied. Expected: 0.
2. Add N37: forall x,y, x^33=y. This is mathematically false (x=0,y=1), beyond
   the exponent cap, and detects a carry from a packed exponent digit into the
   next variable's digit if that cap is removed. Expected: 0.
3. Add N38: forall x, (1000^12)*x=0. Build from x and multiply the symbolic
   accumulator by 1000 twelve times, ensuring no ground-overflow parser gate
   masks polynomial coefficient overflow. This is mathematically false at
   x=1 and detects truncating twelve-limb coefficients. Expected: 0.

The final fixture count is 54: 16 expected accepts and 38 expected rejects.
M05 should additionally test N38; M06 should additionally test N37. Distinguish
false-math acceptance from acceptance of a true but out-of-resource identity.
