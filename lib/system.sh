#!/usr/bin/env bash

get_swap_usage() {
    local total used

    total=$(free -m | awk '/^Swap:/ {print $2}')
    used=$(free -m | awk '/^Swap:/ {print $3}')

    if [[ -z "$total" || "$total" -eq 0 ]]; then
        echo "0"
        return
    fi

    echo $(( used * 100 / total ))
}

get_inode_usage() {
    df -Pi / | awk 'NR==2 {gsub("%","",$5); print $5}'
}
