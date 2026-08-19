# Cloche tests

Smoke test only, for the headless base image (root of the tree — every other Cloche repo builds
on top of it). Not part of the pro-workstation vs cloche-standard parity gap analysis (see
workspace-root `CLAUDE.md`), so this just confirms the recipe builds and produces a sane
rpm-ostree image.

Uses the shared harness — see [cloche-utils/testing/README.md](../../cloche-utils/testing/README.md)
for `test-lib.sh` details, local/CI usage, and the `CLOCHE_UTILS_DIR` env var.

Run: `./tests/run.sh [image-tag]` (`BUILD_METHOD=bluebuild`, builds `./recipes/cloche.yml`).

## Checks

- Recipe builds successfully.
- `rpm-ostree status` runs cleanly inside the built image.
