# Fixture construction clarifications

Author: STARGA Inc.

The pre-execution contract and amendment remain unchanged. Their predicted
maximum depth of 18 for N22 was one too low: its geometric sums explicitly
start with `1*x`, so P16's product reaches depth 18 and N22's additional sum
reaches depth 19. Both are below the documented cap of 32. No byte, expected
outcome, or test decision changes to fix this prose-only counting error.

`resource.mind` is a supporting diagnostic frozen before its own execution.
It checks that P16 accepts with positive polynomial budget remaining and that
N22 rejects with the polynomial budget exactly zero. It reads the documented
implementation diagnostic slot at workspace offset 96. This white-box check
supports the rejection-cause analysis; the original public-API test outcomes
remain authoritative as engineering observations, not mathematical acceptance.
