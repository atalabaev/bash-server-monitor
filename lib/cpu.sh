#!/usr/bin/env bash
cpu_usage() {
  local label user nice system idle iowait irq softirq steal guest guest_nice
  local total1 idle1 total2 idle2 busy delta
  read -r label user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
  total1=$((user+nice+system+idle+iowait+irq+softirq+steal))
  idle1=$((idle+iowait))
  sleep 1
  read -r label user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
  total2=$((user+nice+system+idle+iowait+irq+softirq+steal))
  idle2=$((idle+iowait))
  delta=$((total2-total1))
  ((delta > 0)) || { echo 0; return; }
  busy=$((delta-(idle2-idle1)))
  echo $((100*busy/delta))
}
