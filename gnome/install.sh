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
    gnome-shell-extension-vitals

# Enable extensions
gnome-extensions enable arcmenu@arcmenu.com
gnome-extensions enable forge@jmmaranan.com
gnome-extensions enable gsconnect@andyholmes.github.io
gnome-extensions enable Hide_Activities@shay.shayel.org
gnome-extensions enable order-extensions@wa4557.github.com
gnome-extensions enable Vitals@CoreCoding.com

# Install and set configuration
stow -vv -d $(dirname "$0") -t $HOME config
gsettings set org.gnome.desktop.background picture-uri file:///$HOME/.background.jpg

# Enable Gnome
doas systemctl enable --now gdm
