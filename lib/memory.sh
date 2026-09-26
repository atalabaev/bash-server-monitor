#!/usr/bin/env bash

get_memory_usage() {
    free | awk '/^Mem:/ {
        if ($2 == 0) {
            print 0
        } else {
            printf "%.0f", (($2-$7)/$2)*100
        }
    }'
}
