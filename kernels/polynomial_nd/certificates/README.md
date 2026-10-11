# Exact polynomial certificate bytes

Author: STARGA Inc.

The 54 `.nd.txt` files are emitted by the committed pure-MIND generator in
`../tests/dump.mind` and `../tests/fixtures.mind`. Its independent input is the
numeric index listed in `../tests/CASES.tsv`. The expected results and reasoning
were fixed before execution in `../TEST_CONTRACT.md`, with preserved amendments
in `../tests/TEST_ADJUSTMENTS.md`. The SHA-256 digest of each exact file is in
`../tests/evidence/certificates.sha256`.

`P01_binomial.nd.txt` has the exact closed goal
`forall n:Z, (n+1)*(n+1) = n*n + ((2*n)+1)`.
`P02_scaled_k4.nd.txt` has the exact closed goal
`forall n:Z, (95800*n)^4+(217519*n)^4+(414560*n)^4=(422481*n)^4`,
where each fourth power is two successive squarings.

These universal algebraic identities do not assert positivity, infinitely many
primitive tuples or elliptic-curve membership.
Candidate acceptance is not owner approval of the kernel or a theorem-status
upgrade. Their classification is `FORMAL_PROOF_SUBMITTED`.

Malformed inputs intentionally include extra trailing bytes and a missing final
LF. Preserve bytes exactly; do not format these files as ordinary text.
