# Verification of the published repository

Author: STARGA Inc.
Date: 2026-10-11

The GitHub API reported `star-ga/euler-counterexamples-mind` as public.
An unauthenticated download of published commit
`ecb19ac580d2d8697336ea44e01951e9627c0399` was extracted into a fresh directory.
No GitHub authorization header, repository credential or private checkout was
used to obtain the archive. The download command used `curl -q` to ignore
per-user curl configuration.

```sh
curl -q --fail --location --silent --show-error --connect-timeout 10 --max-time 45 \
  https://codeload.github.com/star-ga/euler-counterexamples-mind/tar.gz/ecb19ac580d2d8697336ea44e01951e9627c0399 \
  -o release.tar.gz
```

Observed archive SHA-256:
`d6762fa66276a0e243238fed5529b0e97332a2466bbd99f4dd3954335ca8925c`.
The archive compressor itself is not part of the mathematical reproducibility
claim; the signed manifest identifies the extracted bytes.

From the extracted public tree, all three initial checks passed:

```sh
sha256sum -c --quiet SHA256SUMS
sha256sum -c --quiet signing/PAYLOAD_SHA256SUMS
sha256sum -c --quiet publication/SOURCE_SHA256SUMS
```

All eight targets below then built and ran successfully from that downloaded
source. The build compilers were the previously qualified public-source
profiles; this check did not rebuild those compilers again.

```sh
make verify test review regression k5-test k5-verify binding-test signed-verify \
  MINDC=/PUBLIC_COMPILER/mindc \
  MINDC_SHA256=c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5 \
  PQC_MINDC=/PQC_COMPILER/mindc
```

Exit 0; empty application/build stderr. K4 verification, its full suite,
33-case independent harness, 1,240-case regression benchmark, full K5 suite,
C5-bound verification, 477-rejection MAP suite, two-key signature verification,
native digest binding and all 1,506 signed payload hashes passed. Final output
was `SIGNED_PAYLOAD=PASS`. Complete stdout, empty stderr and exit value are
retained as `public-download.*`, with operational path replacements documented
by the labels above and `/PUBLIC_DOWNLOAD` / `/FROZEN_SNAPSHOT`.

The public carrier and manifest retain hashes `aade52f3…` and `d3471291…` as
fully recorded in RESULTS.md. Publishing this post-download receipt changes
only excluded execution evidence and the root release checksum manifest;
the signed payload and both signatures stay byte-identical.

This confirms that the published bytes support the recorded reproduction
procedure. It does not authorize formal acceptance or remove the independent
kernel-soundness validation obligation.
