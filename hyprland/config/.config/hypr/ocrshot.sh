#!/usr/bin/env bash

set -euo pipefail

img_path="$(mktemp -t ocrshot-XXXXXX.png)"

cleanup() {
  rm -f "$img_path"
}
trap cleanup EXIT

region="$(slurp)"
if [[ -z "${region}" ]]; then
  exit 0
fi

grim -g "$region" "$img_path"

if ! command -v tesseract >/dev/null 2>&1; then
  notify-send "OCR Screenshot" "tesseract is not installed."
  exit 1
fi

text="$(tesseract -l eng+deu+jpn "$img_path" stdout 2>/dev/null)"
if [[ -n "${text}" ]]; then
  printf "%s" "$text" | wl-copy
  notify-send "OCR Screenshot" "Text copied to clipboard."
else
  notify-send "OCR Screenshot" "No text detected."
fi
