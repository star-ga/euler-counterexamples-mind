# Anonymous public-download verification

Author: STARGA Inc.
Date: 2026-10-11

After pushing audit commit `df6c3be682040c5c5678f74490fc268c029626e2`, an
unauthenticated request downloaded its GitHub source archive:

```sh
env -i PATH=/usr/bin:/bin LC_ALL=C curl -q --fail --silent --show-error --location \
  https://codeload.github.com/star-ga/euler-counterexamples-mind/tar.gz/df6c3be682040c5c5678f74490fc268c029626e2 \
  --output source.tar.gz
tar -xzf source.tar.gz
```

Observed archive SHA-256:
`c84fe66ffb74335e48451d064d1fa090e714d212ad1cb6bd18e7ae0fda9c056b`.

The extracted public `signing/polynomial/verify.sh` was run with the same
qualified c6a4 mathematical compiler, 1550 PQC compiler and CPU6, in an empty
environment except documented tool paths and locale. It rebuilt the pinned MIND
binding checker, verified both public-key-pinned signatures and manifest binding,
and passed all 2,580 file hashes plus exact scope/inventory. Exit was **0**,
stderr was empty, and stdout ended with `POLYNOMIAL_SIGNED_PAYLOAD=PASS`.

The downloaded code and signing artifacts were sufficient; no private source,
private key or GitHub credential was provided. Installed public compiler/backend
dependencies remain necessary. This is same-host anonymous public reproduction,
not independent-machine or independently implemented cryptography.

The following commit adds only these post-signature observations and their
integrity hashes. Neither manifest nor signed carrier changes. Exported stdout
normalizes the temporary verifier directory; raw/export hashes are recorded
in `EXPORT_FILES.tsv`. This report remains outside the signed payload.
