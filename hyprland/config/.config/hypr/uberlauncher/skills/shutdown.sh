#!/usr/bin/env bash

set -euo pipefail

shutdown_items() {
  printf 'shutdown\n'
}

shutdown_run() {
  if ! command -v systemctl >/dev/null 2>&1; then
    notify "Shutdown" "systemctl not found"
    return 1
  fi

  systemctl poweroff
}
