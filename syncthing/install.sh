#!/usr/bin/env bash

set -euo pipefail
set -x

# Installing dependencies
yay -S --needed --noconfirm \
    syncthing

# Start the service
systemctl --user enable --now syncthing.service

echo "open http://localhost:8384/"
