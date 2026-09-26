#!/usr/bin/env bash

check_process() {
    local process="$1"

    if pgrep -x "$process" >/dev/null 2>&1; then
        echo "OK"
        return 0
    fi

    echo "CRITICAL"
    return 2
}

check_service() {
    local service="$1"

    if systemctl is-active --quiet "$service" 2>/dev/null; then
        echo "OK"
        return 0
    fi

    echo "CRITICAL"
    return 2
}

check_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        echo "SKIPPED"
        return 0
    fi

    if systemctl is-active --quiet docker 2>/dev/null; then
        echo "OK"
        return 0
    fi

    echo "CRITICAL"
    return 2
}

check_http() {
    local url="${1:-${CHECK_URL:-http://localhost}}"
    local code

    if ! command -v curl >/dev/null 2>&1; then
        echo "UNKNOWN"
        return 2
    fi

    code=$(curl -L -sS -o /dev/null \
        --connect-timeout 3 \
        --max-time 5 \
        -w "%{http_code}" "$url" 2>/dev/null) || {
            echo "CRITICAL"
            return 2
        }

    if [[ "$code" =~ ^2[0-9][0-9]$|^3[0-9][0-9]$ ]]; then
        echo "OK ($code)"
        return 0
    fi

    echo "CRITICAL ($code)"
    return 2
}
