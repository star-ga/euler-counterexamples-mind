# Euler fifth-power counterexample: MIND candidate derivation

Author: STARGA Inc.

The known Lander–Parkin identity is

`27^5 + 84^5 + 110^5 + 133^5 = 144^5 = 61917364224`.

This benchmark supplies a structured derivation of **not C5**, where

```text
C5 := forall a,b,c,d,e : Z.
      ((a>0 and b>0) and ((c>0 and d>0) and e>0))
      -> not((((a^5+b^5)+c^5)+d^5)=e^5).
```

The quantifiers range over all mathematical integers. Fifth powers are encoded
as `((x*x)*(x*x))*x`. Negation means implication to Bottom. These exact grouping
choices define the statement syntax accepted by the benchmark wrapper.

The unchanged [generic kernel](../../kernels/finite_nd/src/kernel.mind), SHA-256
`ca181abc7430c32c324d10653fba3cca47cbf9a2d2cea30a5c97ec0ac4e13128`, checks every
inference. There are no new proof rules or compiler features. The
[certificate](certificates/P01_c5_refutation.nd.txt) has 52 terms, 61 formulas,
19 proof lines and 1,045 bytes. [The full tables](CERTIFICATE_TABLES.md) identify
F18 as C5, F61 as its negation and F58 as the ground fifth-power equality.

The proof assumes C5, instantiates its five binders with 27, 84, 110, 133 and
144, proves each strict positivity, forms the required conjunction, recomputes
the equality, derives Bottom through two implication eliminations, and
discharges exactly the C5 assumption. Arithmetic uses the existing checked
12-limb base-1000 evaluator. The five powers are respectively 14348907,
4182119424, 16105100000, 41615795893 and 61917364224, far below its refusal bound
`10^36`. No floating-point approximation or trusted equality flag is used.

The additional [binding wrapper](src/binding.mind) first requires generic
kernel acceptance, then checks the validated goal AST for exactly not C5:
five quantifiers, five positive-variable hypotheses, four additive fifth-power
terms with coefficient one, the fifth-power right side, and both negations.
It uses the pinned kernel's documented workspace layout. It does not compare
certificate names, source hashes or the complete certificate against a golden
byte string. Renumbering or unused valid nodes need not change the statement;
algebraically equivalent but differently grouped/scaled formulas are outside
this deliberately exact benchmark binding.

The [test contract](TEST_CONTRACT.md) distinguishes generic acceptance from
C5-bound acceptance. In particular, seven valid proofs of other encoded goals
must pass the kernel and fail the wrapper. All proper prefixes and every
single-byte ASCII-X corruption of the original certificate must fail, with
the unmodified certificate restored and accepted afterwards.

`FORMAL_PROOF_SUBMITTED` describes the submitted candidate derivation.
`NATIVE_VERIFIED` remains unauthorized under the root [proof policy](../../PROOF_POLICY.md).
Execution cannot validate kernel/compiler soundness by itself. This benchmark
makes no RH progress claim and asserts neither discovery nor minimality.

## Historical attribution

L. J. Lander and T. R. Parkin, *Counterexample to Euler's conjecture on sums of
like powers*, Bulletin of the American Mathematical Society 72 (1966), p. 1079,
[primary AMS publication](https://www.ams.org/bull/1966-72-06/S0002-9904-1966-11654-3/S0002-9904-1966-11654-3.pdf),
[DOI](https://doi.org/10.1090/S0002-9904-1966-11654-3).
The historical witness is external mathematics; STARGA Inc. authored this MIND
implementation and formalization. No article text or third-party proof source
is vendored. An external JavaScript formatter generated static fixtures and
used BigInt as a preparation diagnostic. That tool is absent from the runtime
and is not a theorem authority.

See [reproduction and integration](REPRODUCE.md), the frozen pre-execution
manifest, and the separately recorded execution results. The canonical public
repository is [euler-counterexamples-mind](https://github.com/star-ga/euler-counterexamples-mind).
