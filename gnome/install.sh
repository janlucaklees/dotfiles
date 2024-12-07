#!/bin/bash

set -e
set -x

# Installing all zsh related stuff
yay -S --needed --noconfirm \
    gnome \
    gnome-extra \
    gnome-shell-extension-arc-menu \
    gnome-shell-extension-forge \
    gnome-shell-extension-gsconnect \
    gnome-shell-extension-hide-activities-git \
    gnome-shell-extension-order-icons-git \
    gnome-shell-extension-vitals \
    foot

# Enable Gnome
doas systemctl enable --now gdm

# Setup configuration
source ./configure.sh