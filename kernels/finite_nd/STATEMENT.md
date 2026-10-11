# Exact statement

Author: STARGA Inc.

All quantifiers below range over the mathematical integers, without a machine
bound. Define fourth powers by `x^4 = (x*x)*(x*x)` and negation by
`not A = (A -> bottom)`.

```
C4 = forall a:Z. forall b:Z. forall c:Z. forall d:Z.
       ((a>0 and b>0) and (c>0 and d>0)) ->
       not (((a*a)*(a*a) + (b*b)*(b*b)) + (c*c)*(c*c)
            = (d*d)*(d*d))
GOAL = not C4
```

The conjunction grouping is explicit; it is the usual assertion about all
positive integer quadruples. Negative and zero integers remain in the
quantifier domain and make its antecedent false where appropriate. The
checker only computes a bounded nonnegative ground fragment. That implementation
limit restricts which derivations it can accept, not the meaning of `forall`.

Witnesses are `a=95800, b=217519, c=414560, d=422481`. Their fourth powers are
84229075969600000000, 2238663363846304960321, 29535857400192040960000,
and 31858749840007945920321. The sum of the first three equals the fourth.

The new artifact is an independently implemented formal derivation of this
already known counterexample supplied by the owner. It is not a mathematical
discovery and makes no RH progress claim. No third-party implementation is
copied or used as an axiom.

The certificate's actual AST and inference table, rather than its filename or
this prose, determine the proposition checked. The independent review must
bind that AST to this exact statement. The kernel contains no C4 identifier,
Euler witness, special exponent-four rule, or fixed derivation template.
