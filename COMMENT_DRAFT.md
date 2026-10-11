This post inspired us to build a small MIND inference checker for Frye's
known fourth-power counterexample. It checks the exact arithmetic and a
structured derivation of the negation of the stated conjecture, including
universal instantiation and assumption discharge.

We have shared the full source, certificate, soundness argument, adversarial
tests, mutation evidence and reproduction limitations here:
https://github.com/star-ga/euler-k4-mind

The candidate checker accepts the certificate; independent human review of
the kernel is still welcome. This is a formalization effort, not a new
counterexample discovery. Comments on the rules, arithmetic bridge and trust
assumptions would be especially useful.
