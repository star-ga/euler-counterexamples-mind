# Euler K4 predeclared finite test contract

Author: STARGA Inc.

This contract is frozen before any native build or execution. None has run in
the preparation environment. Source inspection and external arithmetic fixture
generation are not native execution evidence.

Required positive controls: the exact supplied tuple and arithmetic certificate
pass arithmetic; its refutation template passes the restricted recognizer;
the zero fixture (0,1,0,1) passes arithmetic. After mutations, the original pair
must pass again. These outcomes remain expected, not observed.

Expected negative checks (1240 total):

| Control | Count |
| --- | ---: |
| Valid zero identity fails positive-domain refutation | 1 |
| Main arithmetic paired with zero refutation fails | 1 |
| Each byte of arithmetic (225 bytes) changed to X | 225 |
| Each byte of refutation (388 bytes) changed to X | 388 |
| Arithmetic witness 95800 changed to 95801 | 1 |
| Each of four statement exponents changed from 4 to 5 | 4 |
| Refutation witness 95800 changed to positive 95801 | 1 |
| Parser rejects 1000000 witness, 1000 limb, 01 and -1 | 4 |
| Every proper prefix of arithmetic | 225 |
| Every proper prefix of refutation | 388 |
| Trailing newline added to either certificate | 2 |

The main harness checks the expected count. Infrastructure errors, timeout,
crash, missing files, unavailable compiler, or failed build are not successful
negative controls. Original source must build and positives must pass before
interpreting rejection behavior. Future actual source-mutant tests should also
remove positivity, arithmetic recomputation, tuple binding and end-of-input
checking independently; those source mutants have NOT been built or tested here.

Pass requires exit 0, ARITHMETIC_CERTIFICATE=PASS, REFUTATION_TEMPLATE=PASS,
NEGATIVE_CASES_EXECUTED=1240 and FINITE_TESTS=PASS. Even then, native formal
acceptance remains blocked and the registry must not be automatically promoted.
