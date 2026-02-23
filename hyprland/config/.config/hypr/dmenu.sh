#!/usr/bin/env bash

set -euo pipefail

# Cache locations (XDG-friendly).
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/dmenu"
cache_file="${cache_dir}/apps.tsv"
cache_hash_file="${cache_dir}/apps.hash"
cache_lock_file="${cache_dir}/apps.lock"
cache_stats_file="${cache_dir}/apps.stats.csv"

# Directories that contain .desktop files.
desktop_roots=(/usr/share/applications "$HOME/.local/share/applications")

# Print all .desktop files under the configured roots.
list_desktop_files() {
  find "${desktop_roots[@]}" -type f -name '*.desktop' -print0 2>/dev/null
}

# Generate a stable hash for the desktop file tree using path, mtime, and size.
desktop_tree_hash() {
  list_desktop_files \
    | xargs -0 stat -c '%n\t%Y\t%s' 2>/dev/null \
    | LC_ALL=C sort \
    | sha256sum \
    | awk '{print $1}'
}

# Parse .desktop files into "Name<TAB>Exec" rows.
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
  done < <(list_desktop_files)
}

# Build the cache file, optionally reusing a precomputed hash.
build_cache() {
  local tmp_file hash
  tmp_file="$(mktemp)"
  list_apps | sort -u -t $'\t' -k1,1 > "${tmp_file}"
  hash="${1:-}"
  if [[ -z "${hash}" ]]; then
    hash="$(desktop_tree_hash)"
  fi
  mkdir -p "${cache_dir}"
  mv "${tmp_file}" "${cache_file}"
  printf '%s\n' "${hash}" > "${cache_hash_file}"
}

# Revalidate the cache in the background.
# This is safe to call frequently; it exits quickly if another run is active.
revalidate_cache() {
  mkdir -p "${cache_dir}"
  exec 9>"${cache_lock_file}"
  flock -n 9 || exit 0

  local new_hash old_hash
  local hash_start_ns hash_end_ns hash_ms
  local build_start_ns build_end_ns build_ms
  local timestamp
  local rebuild=false

  # Time how long hashing takes, to evaluate its cost.
  hash_start_ns="$(date +%s%N)"
  new_hash="$(desktop_tree_hash)"
  hash_end_ns="$(date +%s%N)"
  hash_ms=$(( (hash_end_ns - hash_start_ns) / 1000000 ))
  old_hash=""
  if [[ -f "${cache_hash_file}" ]]; then
    old_hash="$(<"${cache_hash_file}")"
  fi

  if [[ ! -f "${cache_file}" ]] || [[ "${new_hash}" != "${old_hash}" ]]; then
    rebuild=true
    # Time how long cache creation takes.
    build_start_ns="$(date +%s%N)"
    build_cache "${new_hash}"
    build_end_ns="$(date +%s%N)"
    build_ms=$(( (build_end_ns - build_start_ns) / 1000000 ))
  fi

  # Append a CSV row with timings for this run.
  if [[ ! -f "${cache_stats_file}" ]]; then
    printf 'timestamp,hash_ms,build_ms\n' > "${cache_stats_file}"
  fi
  timestamp="$(date -Iseconds)"
  if [[ "${rebuild}" == "true" ]]; then
    printf '%s,%s,%s\n' "${timestamp}" "${hash_ms}" "${build_ms}" >> "${cache_stats_file}"
  else
    printf '%s,%s,\n' "${timestamp}" "${hash_ms}" >> "${cache_stats_file}"
  fi
}

# Return the cached list immediately, building once if it doesn't exist yet.
app_list() {
  if [[ ! -f "${cache_file}" ]]; then
    build_cache
  fi

  if [[ -f "${cache_file}" ]]; then
    cat "${cache_file}"
  else
    list_apps | sort -u -t $'\t' -k1,1
  fi
}

# Optional entry point for background revalidation.
if [[ "${1:-}" == "--revalidate" ]]; then
  revalidate_cache
  exit 0
fi

# Spawn a background revalidation that continues after the menu closes.
nohup "${0}" --revalidate >/dev/null 2>&1 &

selection="$(app_list | fzf --delimiter=$'\t' --with-nth=1 --prompt="> " --border=rounded --height=100%)"

if [[ -z "${selection}" ]]; then
  exit 0
fi

app_cmd="${selection##*$'\t'}"
if [[ -n "${app_cmd}" ]]; then
  hyprctl dispatch exec "${app_cmd}"
fi
