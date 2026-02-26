#!/usr/bin/env bash

set -euo pipefail

lock_items() {
  printf 'lock\n'
}

lock_run() {
  if ! command -v hyprctl >/dev/null 2>&1; then
    notify "Lock" "hyprctl not found"
    return 1
  fi

  if ! command -v hyprlock >/dev/null 2>&1; then
    notify "Lock" "hyprlock not found"
    return 1
  fi

  hyprctl dispatch exec "hyprlock" >/dev/null 2>&1
}
