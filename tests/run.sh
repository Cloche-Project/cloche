#!/usr/bin/env bash
# Smoke test entrypoint for Cloche (headless base image). See tests/README.md
# for scope and the unverified path to confirm before trusting this in CI.

set -uo pipefail

UTILS_DIR="${CLOCHE_UTILS_DIR:-../cloche-utils}"
# shellcheck source=../../cloche-utils/testing/test-lib.sh
source "$UTILS_DIR/testing/test-lib.sh"

IMAGE="${1:-cloche-test}"
BUILD_METHOD="bluebuild"
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
