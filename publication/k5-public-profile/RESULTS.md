# Public compiler integration checks

Author: STARGA Inc.

Using public-source compiler SHA-256
`c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5`,
the root command was:

```sh
make k5-test k5-verify binding-check binding-test \
  MINDC=/PUBLIC_COMPILER/mindc \
  MINDC_SHA256=c6a4cdce63a76af95025de2664ade696df9f3dbd1b9a84f4a77e6379e6811ea5
```

Exit: 0. Application tests passed their original contracts. Make stdout/stderr
are retained with operational paths replaced by `/PUBLIC_REPO` and
`/PUBLIC_COMPILER`. These are separate, newly measured builds; the historical
pin and receipts have not been changed.

| Program | Produced ELF SHA-256 |
| --- | --- |
| K5 suite | `38b0fcf7bc6ef57b7a1cc54022fd19d46aba3a0eae376181c7da2dbb3a003bb7` |
| K5 CLI | `d85194109b7306cdc9ee0702c3e14929374a09c3cf6fee85c02d7a4cd07366a8` |
| MAP binding CLI | `704e836dd8f1bbbc864ad3f601d95648e13825c478fd69adb33031cf31f83cce` |
| MAP binding suite | `3868498912f6505797356f8ea96da214c6403dba900d218568b12def5569cee9` |

The K5 ELF bytes differ from the historical compiler's outputs. For the K5
CLI, inspected `.text`, `.rodata`, `.data` and `.eh_frame` bytes matched, while
the original ELF declares an additional `libm.so.6` dependency. This is an
observed linkage difference, not a proved exhaustive explanation of every
binary difference. No K5 cross-profile ELF bit-identity claim is made.
The complete finite suites and exact CLI success output passed under both
profiles. The older K4 four-program bit-identity result has its own evidence.
