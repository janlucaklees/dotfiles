#!/usr/bin/env bash

set -euo pipefail

# Constants
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="${SCRIPT_DIR}/skills"

# Arrays / registries
skill_ids=()
skill_items_fns=()
skill_run_fns=()

notify() {
  local title="$1"
  local msg="$2"
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -t 5000 "${title}" "${msg}"
  else
    echo "${title}: ${msg}"
  fi
}

load_skills() {
  local f
  for f in "$SKILL_DIR"/*.sh; do
    [[ -f "$f" ]] || continue
    source "$f"

    # Konvention: <name>_id / <name>_items / <name>_run existiert
    # Wir leiten name aus Dateiname ab:
    local name="${f##*/}"; name="${name%.sh}"
    local safe_name="${name//-/_}"

    # Minimalcheck:
    declare -F "${safe_name}_items" >/dev/null || continue

    skill_ids+=("$name")
    skill_items_fns+=("${safe_name}_items")
    # run ist optional
    if declare -F "${safe_name}_run" >/dev/null; then
      skill_run_fns+=("${safe_name}_run")
    else
      skill_run_fns+=("")
    fi

  done
}

items_for_query() {
  local i fn
  for i in "${!skill_items_fns[@]}"; do
    fn="${skill_items_fns[$i]}"
    "$fn"
  done
}

dispatch_line() {
  local line="$1"
  if [[ "$line" == *$'\t'* ]]; then
    local payload="${line#*$'\t'}"
    if [[ "$payload" == *:* ]]; then
      local pskill="${payload%%:*}"
      local prest="${payload#*:}"
      line="${pskill} ${prest}"
    else
      line="$payload"
    fi
  fi

  local head="${line%% *}"

  local i name runfn
  for i in "${!skill_ids[@]}"; do
    name="${skill_ids[$i]}"
    if [[ "$head" == "$name" ]]; then
      runfn="${skill_run_fns[$i]}"
      if [[ -n "$runfn" ]]; then
        "$runfn" "$line"
        return $?
      fi
    fi
  done

  # Fallback: wenn kein Skill matched, versuch als command zu starten
  if command -v "$head" >/dev/null 2>&1; then
    nohup $line >/dev/null 2>&1 & disown || true
    return 0
  fi

  echo "Unknown: $line" >&2
  return 1
}

load_skills

selection="$(
  items_for_query \
    | fzf --print-query \
      --bind "enter:accept" \
      --prompt='> ' \
      --height=100% \
      --layout=reverse
)" || true

query="$(printf "%s\n" "$selection" | sed -n '1p')"
picked="$(printf "%s\n" "$selection" | sed -n '2p')"
line="${picked:-$query}"
[[ -z "${line// /}" ]] && exit 0

dispatch_line "$line"
