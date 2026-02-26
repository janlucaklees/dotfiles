#!/usr/bin/env bash

set -euo pipefail

restart_items() {
  printf 'restart\n'
}

restart_run() {
  if ! command -v systemctl >/dev/null 2>&1; then
    notify "Restart" "systemctl not found"
    return 1
  fi

  systemctl reboot
}
