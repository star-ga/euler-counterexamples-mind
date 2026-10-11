# Test corrections and supplemental coverage

Author: STARGA Inc.

The original TEST_CONTRACT.md is unchanged (SHA-256
03a5825aee197064f8c65332463502a55c1ff9976edd3f0bc161db23363f5e61).
Its 1,240 negative checks and intended assertions remain required.

1. **Witness-edit offset correction.** The arithmetic header is 18 bytes; 95800
   occupies offsets 18 through 22. The downloaded main.mind changed offset 21,
   producing 95810, although its comment and contract specified 95801. Correct
   the two write/restore offsets to 22. This aligns execution with the existing
   contract without changing its count. The initial supplemental probe inherited
   that offset and paired 95810 with 95801, falsely masking the coherent-pair
   recomputation fault. Correct its input check and two writes to 22 as well.
   Keep the original source snapshots and initial campaign receipts in evidence;
   rebuild and rerun all ten corrected harness/probe variants.
2. **Additional direct arithmetic coverage.** The original changed-witness case
   tests through refutation. Tuple binding can hide missing power recomputation.
   Six supplemental probes independently expose each removed safeguard, including
   both direct arithmetic and a coherently changed pair of witnesses. The
   recomputation mutant can pass all original 1,240 checks; that survival is
   reported, not treated as a successful mutation rejection.
3. **Build layout correction.** Early scratch builds outside their project
   directory failed import resolution. Adding the manifest without changing
   directory did not fix it. A third attempt included two entry points in one
   source directory and failed linking. Successful builds use one manifest and
   one src/main.mind plus checker.mind per isolated project, with that project
   as the working directory. The supplemental source lives outside the ordinary
   src directory. These three failures are retained infrastructure failures.
4. **Arithmetic-bound prose.** State the carry<x induction only for x>0, with
   x=0 handled separately. The production checker already handles zero correctly;
   its source is unchanged.

None of these corrections changes certificate bytes, the mathematical statement,
the compiler pin, status policy, or the boundary between template checking and
accepted formal proof.
