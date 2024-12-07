#!/bin/bash

set -e
set -x

# Installing dependencies
yay -S --needed --noconfirm \
    bluez \
    bluez-utils

# Start the service
systemctl enable --now bluetooth.service
