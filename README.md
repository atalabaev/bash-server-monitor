# Bash Server Monitor

A modular Bash CLI utility for Linux server health monitoring.

## v0.1 — initial working release

The first release checks **CPU, RAM, disk utilization, and 1-minute load average**. It provides configurable warning/critical thresholds, `--help`, `--version`, `--quiet`, and Nagios-style exit codes (`0` OK, `1` WARNING, `2` CRITICAL, `3` UNKNOWN/error).

This is a staged portfolio project, **not yet the full monitoring platform**.

## Quick start

```bash
chmod +x bin/server-monitor
./bin/server-monitor --help
./bin/server-monitor
cp config/config.example config/config.conf
./bin/server-monitor --config config/config.conf
```

Requires Linux, Bash, `awk`, `df`, and `/proc` (tested target: Ubuntu Server 24.04 ARM64). Run on the server, not directly on macOS.

## Example output

```text
SERVER HEALTH REPORT | web01 | 2026-09-24T18:00:00Z
CPU      OK       3%
RAM      OK       8%
DISK     OK       29%
LOAD     OK       0.01
```

The values above are illustrative, not actual test evidence.

## Roadmap

- [x] v0.1: CPU, RAM, disk, load, configurable thresholds and CLI
- [ ] v0.2: swap, inodes, network, DNS, processes, systemd, Docker and HTTP checks
- [ ] v0.3: webhook alerting, logs, automated tests, ShellCheck CI and failure demonstrations

## Security

`config/config.conf` is gitignored. Only use a trusted local configuration file; it is sourced as Bash code. Never commit webhook tokens or other credentials.
