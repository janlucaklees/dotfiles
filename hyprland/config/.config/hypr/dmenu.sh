#!/usr/bin/env bash
set -euo pipefail

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/dmenu"
cache_file="${cache_dir}/apps.tsv"
cache_ttl_seconds=300

list_apps() {
  local file name exec_cmd nodisplay hidden
  while IFS= read -r -d '' file; do
    # Parse desktop entry metadata in a single pass.
    IFS=$'\t' read -r name exec_cmd nodisplay hidden < <(
      awk '
        /^Name=/ && !name {
          name = $0
          sub(/^Name=/, "", name)
        }
        /^Exec=/ && !exec_cmd {
          exec_cmd = $0
          sub(/^Exec=/, "", exec_cmd)
        }
        /^NoDisplay=/ && !nodisplay {
          nodisplay = tolower($0)
          sub(/^NoDisplay=/, "", nodisplay)
        }
        /^Hidden=/ && !hidden {
          hidden = tolower($0)
          sub(/^Hidden=/, "", hidden)
        }
        END { printf "%s\t%s\t%s\t%s\n", name, exec_cmd, nodisplay, hidden }
      ' "${file}"
    )

    [[ -z "${name}" ]] && continue
    [[ -z "${exec_cmd}" ]] && continue
    [[ "${nodisplay}" == "true" ]] && continue
    [[ "${hidden}" == "true" ]] && continue

    # Remove desktop entry placeholders (e.g. %U, %f) before execution.
    exec_cmd="$(printf '%s' "${exec_cmd}" | sed -E 's/%%/\x01/g; s/%[fFuUdDnNickvm]//g; s/\x01/%/g; s/[[:space:]]+$//')"
    [[ -z "${exec_cmd}" ]] && continue

    printf '%s\t%s\n' "${name}" "${exec_cmd}"
  done < <(find /usr/share/applications "$HOME/.local/share/applications" -type f -name '*.desktop' -print0 2>/dev/null)
}

cache_is_fresh() {
  [[ -f "${cache_file}" ]] || return 1
  (( EPOCHSECONDS - $(stat -c %Y "${cache_file}") < cache_ttl_seconds ))
}

build_cache() {
  local tmp_file
  tmp_file="$(mktemp)"
  list_apps | sort -u -t $'\t' -k1,1 > "${tmp_file}"
  mkdir -p "${cache_dir}"
  mv "${tmp_file}" "${cache_file}"
}

app_list() {
  if ! cache_is_fresh; then
    build_cache
  fi

  if [[ -f "${cache_file}" ]]; then
    cat "${cache_file}"
  else
    list_apps | sort -u -t $'\t' -k1,1
  fi
}

selection="$(app_list | fzf --delimiter=$'\t' --with-nth=1 --prompt="> " --border=rounded --height=100%)"

if [[ -z "${selection}" ]]; then
  exit 0
fi

app_cmd="${selection##*$'\t'}"
if [[ -n "${app_cmd}" ]]; then
  hyprctl dispatch exec "${app_cmd}"
fi
