#!/usr/bin/env bash

get_disk_usage() {
    df -P / | awk 'NR==2 {
        gsub("%", "", $5)
        print $5
    }'
}
