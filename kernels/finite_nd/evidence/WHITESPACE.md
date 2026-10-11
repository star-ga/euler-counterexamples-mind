# Intentional raw-byte whitespace

Author: STARGA Inc.

Unfiltered `git diff --check` reports expected whitespace in deliberately
malformed CRLF/trailing-LF certificates, matching independent fixtures,
readelf header output, Windows/SSH CRLF receipts, and a unified-diff context
line. These bytes are retained exactly to preserve the frozen test contract
and raw observations. They are not normalized to make a formatting gate pass.
Source and prose whitespace are checked separately, excluding only certificate
data, raw evidence and recorded mutation patches. The governance and artifact
checksum gates still include every tracked file in those directories.
