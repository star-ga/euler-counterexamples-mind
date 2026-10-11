# Building the finite suite

Author: STARGA Inc.

Use a fresh scratch project. Copy `tests/Mind.toml` to its root. Create `src/`
and copy these exact sources without editing or concatenating them:

| Repository source | Scratch destination |
|---|---|
| `tests/main.mind` | `src/main.mind` |
| `tests/fixtures.mind` | `src/fixtures.mind` |
| `src/kernel.mind` | `src/kernel.mind` |

Run the pinned compiler from the scratch project directory with
`build src/main.mind --backend mlir --target cpu --emit binary --optimize debug
--no-cache --out check`. Verify ELF output before executing `check`.
Runtime and compiler identity must follow the repository's pinned toolchain
instructions. Builds and tests remain CPU-only and resource bounded.

The suite takes no external inputs: every acceptance decision is made by
MIND against the frozen literals corresponding to the `.nd.txt` files.
The separate generic CLI can check those certificate files through stdin.
Keep the files under `src/`; staging them directly at the scratch project root
failed module resolution on the tested compiler pin.
