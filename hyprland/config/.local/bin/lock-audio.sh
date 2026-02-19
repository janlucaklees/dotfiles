#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="${XDG_RUNTIME_DIR:-/run/user/$UID}"
STATE_FILE="$STATE_DIR/hyprlock-audio.state"

# Save current state
wpctl get-volume @DEFAULT_AUDIO_SINK@ > "$STATE_FILE"

touch "/run/user/$UID/hypridle-audio.log"
echo "Saving audio state to $STATE_FILE" >> "/run/user/$UID/hypridle-audio.log"

# Mute
wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
