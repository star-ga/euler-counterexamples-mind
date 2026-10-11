# Independent review archive

Author: STARGA Inc.

Publication disclosure: review was performed by an AI agent assigned separately
from implementation. It was not external human validation. Any approval still
follows the public PROOF_POLICY.md.

This directory contains the independently authored MIND probe, frozen prelist, static certificate fixtures and sanitized public copies of observations. It contains no JavaScript generator, foreign-language runtime, or ELF binary. The numerical JSON-formatted `.log` files are external review diagnostics, not proof authority or executable test logic.

The independent probe source embeds all 33 input certificates and performs all acceptance decisions in MIND. Reproduce in an isolated project by copying `probe/`, copying the reviewed canonical `kernels/finite_nd/src/kernel.mind` into its `src/` directory, verifying kernel SHA ca181abc7430c32c324d10653fba3cca47cbf9a2d2cea30a5c97ec0ac4e13128, and using the exact compiler/environment/limits recorded in `independent-build.time.txt`. Change only scratch and output paths. `probe/Mind.toml` uses the conventional src/main.mind entry.

`PRELIST.log` has exactly the frozen bytes formerly named PRELIST.json (SHA a22494985ab4fdb2c891631e6ffd10307a918b1ebe80254282f1c39fd4ac75dd). Its original fixture paths end `.cert`; archived fixtures append `.txt` without changing any content. Their original SHA values remain valid. Source/hash receipts retain original scratch paths as provenance, not promises that those paths exist on another machine.

The source-consistency diagnostic initially used an unanchored Markdown-row expression, double-counting proof-table formula references. The initial diagnostic and corrected result are both retained; this was a reviewer diagnostic correction, not a source/test failure. The successful final diagnostic checked all 57 embedded fixture strings and all 31 term/46 formula rows against raw certificate bytes.

Mutation reruns use the already built, hash-audited integration ELFs; the independently authored probe was freshly built by the reviewer. `REVIEW.md` distinguishes these checks, their shared compiler/machine limits, and the still-required owner/designated-verifier proof-policy approval.
