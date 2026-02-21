#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
data_file="${script_dir}/emojipickr.data"

if [[ ! -r "${data_file}" ]]; then
  notify-send "Emoji picker" "Missing data file: ${data_file}"
  exit 1
fi

selection="$(
  fzf \
    --prompt="emoji> " \
    --border=rounded \
    --height=100% \
    "$@" < "${data_file}" || true
)"
if [[ -z "${selection}" ]]; then
  exit 0
fi

emoji="${selection%% *}"
if [[ -z "${emoji}" ]]; then
  exit 0
fi

printf '%s' "${emoji}" | wl-copy
printf '%s' "${emoji}" | wtype -
