#!/bin/bash

set -e
set -x

echo "Please enable the multilib repository in /etc/pacman.conf"

# Installing dependencies
yay -S --needed --noconfirm \
    vulkan-icd-loader \
    vulkan-radeon \
    vulkan-tools \
    lib32-vulkan-icd-loader \
    lib32-vulkan-radeon \
    lib32-vulkan-tools \
    lib32-pipewire \
    lib32-pipewire-jack \
    lib32-libnm \
    lib32-freetype2 \
    steam \
    protonup-qt \
