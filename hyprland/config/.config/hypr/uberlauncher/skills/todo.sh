#!/usr/bin/env bash

set -euo pipefail

todo_items() {
  printf 'todo\n'
  printf 't\n'
}

todo_run() {
  local line="$1"
  local text="${line}"

  notify "${line}"

  if [[ "${line}" =~ ^[[:space:]]*(todo|t)[[:space:]]+(.+)$ ]]; then
    text="${BASH_REMATCH[2]}"
  else
    notify "Todo" "Usage: todo <text>"
    return 1
  fi

  local env_file
  env_file="$(dirname "${BASH_SOURCE[0]}")/todo.env"
  if [[ ! -f "${env_file}" ]]; then
    notify "Todo" "Missing todo.env"
    return 1
  fi

  set -a
  # shellcheck source=/dev/null
  source "${env_file}"
  set +a

  if [[ -z "${TODOIST_API_TOKEN:-}" ]]; then
    notify "Todo" "TODOIST_API_TOKEN not set"
    return 1
  fi

  if ! command -v curl >/dev/null 2>&1; then
    notify "Todo" "curl not found"
    return 1
  fi

  local esc="${text}"
  esc="${esc//\\/\\\\}"
  esc="${esc//\"/\\\"}"
  esc="${esc//$'\n'/\\n}"
  esc="${esc//$'\r'/\\r}"
  esc="${esc//$'\t'/\\t}"
  local json_payload="{\"text\":\"${esc}\"}"

  local tmp_body http_code
  tmp_body="$(mktemp)"
  http_code="$(curl -sS -o "${tmp_body}" -w "%{http_code}" \
    -X POST "https://api.todoist.com/api/v1/tasks/quick" \
    -H "Authorization: Bearer ${TODOIST_API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "${json_payload}" || true)"

  if [[ -z "${http_code}" ]]; then
    notify "Todo" "Request failed"
    rm -f "${tmp_body}"
    return 1
  fi

  if [[ "${http_code}" =~ ^2 ]]; then
    notify "Todo" "Added: ${text}"
  else
    notify "Todo" "Failed (${http_code})"
    rm -f "${tmp_body}"
    return 1
  fi

  rm -f "${tmp_body}"
}
