#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="${XDG_RUNTIME_DIR:-/run/user/$UID}"
STATE_FILE="$STATE_DIR/hyprlock-audio.state"

[[ -f "$STATE_FILE" ]] || exit 0

# Example saved line formats:
# "Volume: 0.45"
# "Volume: 0.45 [MUTED]"
line="$(cat "$STATE_FILE")"

vol="$(sed -n 's/^Volume: \([0-9.]\+\).*$/\1/p' <<<"$line")"
was_muted=0
grep -q 'MUTED' <<<"$line" && was_muted=1

touch "/run/user/$UID/hypridle-audio.log"
echo "Resetting volume to $vol" >> "/run/user/$UID/hypridle-audio.log"
echo "Resetting mute state to $was_muted" >> "/run/user/$UID/hypridle-audio.log"

wpctl set-volume @DEFAULT_AUDIO_SINK@ "$vol"
wpctl set-mute @DEFAULT_AUDIO_SINK@ "$was_muted"

rm -f "$STATE_FILE"
