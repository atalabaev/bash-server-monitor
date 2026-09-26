#!/usr/bin/env bash

get_cpu_usage() {
    local cpu idle

    cpu=$(LC_ALL=C top -bn1 | awk '/Cpu\(s\)/ {
        for (i=1; i<=NF; i++) {
            if ($i ~ /id,?$/) {
                print $(i-1)
                exit
            }
        }
    }')

    idle="${cpu:-100}"
    awk -v idle="$idle" 'BEGIN {printf "%.0f", 100-idle}'
}
