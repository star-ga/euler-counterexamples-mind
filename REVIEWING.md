# Review this candidate

Author: STARGA Inc.

Please open an issue containing a technical review or counterexample. Merely
stating approval does not establish mathematical acceptance. Identify your
reviewed commit, certificate SHA-256 and checker SHA-256, commands/environment,
observed results, and any assumptions or unexamined components.

Review targets:

1. The displayed C4 and the certificate AST have exactly the same meaning.
2. Limb arithmetic proves ground positivity/equality without overflow or
   accepting an asserted result. The arithmetic facts bind to the logical terms.
3. Universal elimination performs capture-safe substitution for the exact
   witness and checks the complete resulting formula.
4. Every premise is in scope, assumption identities remain fresh, and negation
   introduction discharges exactly the intended C4 assumption.
5. Parsing, complete-input handling, resource bounds and unsupported syntax
   cannot turn malformed input into an accepted proof.
6. The soundness argument matches every implemented rule and the actual TCB.

Reproduce the positive/negative suite and source mutations. Report crashes and
timeouts as infrastructure failures, not successful proof rejection. A review
may find a bug in this implementation even though the historical arithmetic
counterexample is correct.

The existing review was performed by a separate AI agent, not an external human
verifier. Review independence here means separation of implementation and review
tasks, not a different compiler or a formally verified reviewer.

Review comments do not grant authorship, copyright ownership, collaborator
access or permission to merge external code contributions. Those remain owner
decisions. Report sensitive security details privately to the repository owner.
