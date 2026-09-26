#!/usr/bin/env bash

set -uo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MONITOR="${PROJECT_DIR}/bin/server-monitor"

PASSED=0
FAILED=0

pass() {
    printf '[ OK ] %s\n' "$1"
    PASSED=$((PASSED + 1))
}

fail() {
    printf '[FAIL] %s\n' "$1"
    FAILED=$((FAILED + 1))
}

echo "Running bash-server-monitor smoke tests..."
echo

if bash -n "$MONITOR" "${PROJECT_DIR}"/lib/*.sh; then
    pass "Bash syntax"
else
    fail "Bash syntax"
fi

if "$MONITOR" --help >/dev/null 2>&1; then
    pass "--help"
else
    fail "--help"
fi

if "$MONITOR" --version >/dev/null 2>&1; then
    pass "--version"
else
    fail "--version"
fi

for fn in get_cpu_usage get_memory_usage get_disk_usage get_swap_usage get_inode_usage get_network_status get_dns_status check_process check_service check_docker check_http
do
    if grep -Rqs "^${fn}()" "${PROJECT_DIR}/lib"; then
        pass "function ${fn}"
    else
        fail "function ${fn}"
    fi
done

if grep -qs 'WEBHOOK_URL' "$MONITOR"; then
    pass "webhook alerting configured"
else
    fail "webhook alerting configured"
fi

if grep -qs 'LOG_FILE' "$MONITOR"; then
    pass "logging configured"
else
    fail "logging configured"
fi

echo
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if (( FAILED > 0 )); then
    exit 1
fi

echo "All static smoke tests passed."
exit 0
