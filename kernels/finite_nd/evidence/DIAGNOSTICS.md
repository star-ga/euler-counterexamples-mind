# Optional external mathematics diagnostics

Author: STARGA Inc.

These computations are not kernel rules, proof dependencies or project test
executables. The native MIND proof check does not invoke them. They were
run separately as research cross-checks on the owner's existing fleet.

- A SymPy exact simplification of the public witness residual returned integer
  zero. The local skill calculator source hash was
  f7d8423b44ca44c3f96aa66c3e0a16058142af130dcda9810b7566d3b07ede3b.
- HOST_B Z3 returned four `unsat` answers to the negations of the witness equality,
  witness positivity and elementary addition/multiplication limb bounds.
- HOST_C's native Windows cvc5 independently returned the same four answers. Its
  executable SHA was fc71384cb2dba76ad775cd6088de76c3f4db10bb1cc594fa4cfcd3110b576c3b.
  The first invocation lacked incremental mode and included a Z3-specific
  timeout option: it printed unsupported/error despite exit zero. That failed
  diagnostic is preserved and not counted. The final invocation used
  `--lang=smt2 --incremental --tlimit=5000`, with the incompatible option removed.

The Z3 executable SHA was
450bffa1b87541409c37cd678b2e7261c5d20912144e5c052fd264b1f3a2077f.
Solver input is archived as mathematical diagnostic data in `.smt2.txt` files;
no foreign-language implementation or runtime is introduced by these receipts.
Local/fleet versions and hashes do not establish solver correctness. Independent
native-kernel checks remain the proof-certificate execution evidence.
