#!/usr/bin/env bash

set -euo pipefail

wifi_known_connections() {
  if command -v nmcli >/dev/null 2>&1; then
    nmcli -t -f NAME,TYPE connection show 2>/dev/null \
      | awk -F: 'tolower($2) ~ /(wifi|wireless)/ {print $1}'
  fi
}

wifi_items() {
  printf 'wifi on\n'
  printf 'wifi off\n'
  printf 'wifi toggle\n'

  local name
  while IFS= read -r name; do
    [[ -n "${name}" ]] || continue
    printf 'wifi %s\n' "${name}"
  done < <(wifi_known_connections)
}

wifi_run() {
  local line="$1"
  local action="${line}"
  if [[ "${line}" =~ ^[[:space:]]*(wifi|w)[[:space:]]+(.+)$ ]]; then
    action="${BASH_REMATCH[2]}"
  fi

  if ! command -v nmcli >/dev/null 2>&1; then
    notify "WiFi" "nmcli not found (NetworkManager not installed?)"
    return 1
  fi

  case "${action}" in
    on)
      if nmcli radio wifi on; then
        notify "WiFi" "Enabled"
      else
        notify "WiFi" "Failed to enable"
        return 1
      fi
      ;;
    off)
      if nmcli radio wifi off; then
        notify "WiFi" "Disabled"
      else
        notify "WiFi" "Failed to disable"
        return 1
      fi
      ;;
    *)
      if nmcli connection up id "${action}"; then
        notify "WiFi" "Connected: ${action}"
      else
        notify "WiFi" "Failed: ${action}"
        return 1
      fi
      ;;
  esac
}
