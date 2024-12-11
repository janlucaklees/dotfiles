#!/bin/bash

set -e
set -x

# Installing dependencies
yay -S --needed --noconfirm \
    cups \
    cups-pdf \
    kyocera-ecosys-m552x-p502x

# Start the service
systemctl enable --now cups.service
