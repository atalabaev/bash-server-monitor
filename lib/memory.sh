#!/usr/bin/env bash
ram_usage() {
  awk '/^MemTotal:/ {total=$2} /^MemAvailable:/ {available=$2} END {if (total > 0) printf "%.0f\n", (total-available)*100/total; else exit 1}' /proc/meminfo
}
