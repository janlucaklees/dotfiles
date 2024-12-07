#!/bin/bash

set -e
set -x

# Installing dependencies
yay -S --needed --noconfirm \
    syncthing

# Start the service
systemctl --user enable --now syncthing.service
