#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
bash -n "$ROOT/bin/server-monitor" "$ROOT/lib/cpu.sh" "$ROOT/lib/memory.sh" "$ROOT/lib/disk.sh"
"$ROOT/bin/server-monitor" --help >/dev/null
"$ROOT/bin/server-monitor" --version | grep -q '0.1.0'
"$ROOT/bin/server-monitor" >/dev/null
printf 'Static checks and healthy-run smoke test passed.\n'
