#!/usr/bin/env bash
disk_usage() {
  local path="$1"
  df -P "$path" | awk 'NR==2 {gsub(/%/, "", $5); print $5}'
}
