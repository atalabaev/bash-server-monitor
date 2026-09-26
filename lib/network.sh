#!/usr/bin/env bash

get_network_status() {
    local host="${NETWORK_HOST:-1.1.1.1}"

    if ping -c 1 -W 2 "$host" >/dev/null 2>&1; then
        echo "OK"
        return 0
    fi

    echo "CRITICAL"
    return 2
}

get_dns_status() {
    local domain="${DNS_HOST:-example.com}"

    if getent hosts "$domain" >/dev/null 2>&1; then
        echo "OK"
        return 0
    fi

    echo "CRITICAL"
    return 2
}
