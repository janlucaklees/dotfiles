#!/bin/bash

set -e
set -x

# Installing dependencies
yay -S --needed --noconfirm \
    bluez \
    bluez-utils \
    bluetooth-autoconnect

# Start the service
systemctl enable --now bluetooth.service
systemctl enable --now bluetooth-autoconnect
