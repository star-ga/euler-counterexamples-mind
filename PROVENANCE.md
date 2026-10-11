# Mathematical and implementation provenance

Author: STARGA Inc.

The exact witness 95800, 217519, 414560, 422481 is Roger E. Frye's published
fourth-power counterexample. Primary sources:

- Roger E. Frye, *Finding a small solution to A^4+B^4+C^4=D^4*,
  Supercomputing '88, pp. 106–116,
  [DOI 10.1109/SUPERC.1988.74138](https://doi.org/10.1109/SUPERC.1988.74138).
- Noam D. Elkies, *On A^4+B^4+C^4=D^4*, Mathematics of Computation
  51(184), 1988, pp. 825–835. The Postscript discusses Frye's search and this
  tuple: [AMS paper](https://www.ams.org/journals/mcom/1988-51-184/S0025-5718-1988-0930224-9/S0025-5718-1988-0930224-9.pdf).

This package checks the stated witness and a logical refutation of C4.
It does not prove minimality, discover a new witness or reproduce the historical
search. No manuscript, article image, third-party proof implementation or
private research data is vendored. The owner supplied the witness and a social
post as motivation. The post's image and unverified timing claims are not
redistributed or relied upon.

The fifth-power witness 27, 84, 110, 133, 144 is due to L. J. Lander and
T. R. Parkin, *Counterexample to Euler's conjecture on sums of like powers*,
Bulletin of the American Mathematical Society 72 (1966), p. 1079,
[DOI 10.1090/S0002-9904-1966-11654-3](https://doi.org/10.1090/S0002-9904-1966-11654-3).
The new K5 certificate uses the unchanged inference kernel. This is a
formalization of that known witness, not a new counterexample or discovery.

STARGA Inc. is the author of this original MIND implementation,
formalization and documentation. AI tools assisted implementation and review;
they are neither authors nor mathematical authorities. Fixture generation used
external arithmetic diagnostics, while all committed executable mathematical
checks and test decisions are MIND.

The public repository begins with a new history. Publication metadata may
redact operational details from archived receipts; the actual kernel, CLI,
MIND tests, certificate fixtures and mutation diffs are preserved byte-for-byte.
`publication/SOURCE_SHA256SUMS` identifies those immutable proof artifacts.
The current release manifest identifies the public documentation and evidence
copies. No unreviewed private repository history is imported.
