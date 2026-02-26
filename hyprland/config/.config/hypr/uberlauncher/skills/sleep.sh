#!/usr/bin/env bash

set -euo pipefail

sleep_items() {
  printf 'sleep\n'
}

sleep_run() {
  if command -v hyprlock >/dev/null 2>&1; then
    hyprlock
  elif command -v loginctl >/dev/null 2>&1; then
    loginctl lock-session
  fi

  if command -v systemctl >/dev/null 2>&1; then
    systemctl suspend
  else
    echo "sleep: systemctl not found" >&2
    return 1
  fi
}
