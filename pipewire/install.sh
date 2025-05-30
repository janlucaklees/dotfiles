#!/bin/bash

set -e
set -x

# Installing dependencies
yay -S --needed \
    pipewire \
    pipewire-audio \
    pipewire-alsa \
    pipewire-pulse \
    pipewire-jack \
    wireplumber \
    easyeffects \
    calf \
    lsp-plugins \
    libdeep_filter_ladspa-bin

# Start the service
systemctl --user enable --now pipewire.service pipewire-pulse.service wireplumber.service
