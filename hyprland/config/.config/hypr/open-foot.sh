#!/usr/bin/env bash

set -euo pipefail

last_dir_file="${XDG_CACHE_HOME:-$HOME/.cache}/foot/last-dir"
start_dir="${HOME}"

if [[ -r "${last_dir_file}" ]]; then
  read -r cached_dir < "${last_dir_file}" || true
  if [[ -n "${cached_dir:-}" && -d "${cached_dir}" ]]; then
    start_dir="${cached_dir}"
  fi
fi

exec footclient --term xterm-256color --working-directory "${start_dir}" "$@"
