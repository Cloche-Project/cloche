#!/usr/bin/env bash
# Smoke test entrypoint for Cloche (headless base image). See tests/README.md
# for scope and the unverified path to confirm before trusting this in CI.

set -uo pipefail

UTILS_DIR="${CLOCHE_UTILS_DIR:-../cloche-utils}"
# shellcheck source=../../cloche-utils/testing/test-lib.sh
source "$UTILS_DIR/testing/test-lib.sh"

# shellcheck disable=SC2034 # used by test-lib.sh (cloche-utils, a separate repo Codacy can't see)
IMAGE="${1:-cloche-test}"
# shellcheck disable=SC2034 # used by test-lib.sh (cloche-utils, a separate repo Codacy can't see)
BUILD_METHOD="bluebuild"
# shellcheck disable=SC2034 # used by test-lib.sh (cloche-utils, a separate repo Codacy can't see)
RECIPE="./recipes/cloche.yml"

test_rpm_ostree_status() {
    exec_in_image "rpm-ostree status"
}

main() {
    build_image || { echo "Build failed, aborting tests."; exit 1; }

    echo ""
    echo "=== Smoke tests ==="
    run_check "recipe builds"       true
    run_check "rpm-ostree healthy"  test_rpm_ostree_status

    print_summary
}

main
