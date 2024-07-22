#!/usr/bin/env bash

# Installing all zsh related stuff
yay -S --needed --noconfirm gnome gnome-extra gnome-shell-extension-pop-shell gnome-shell-extension-vitals

# Install all configuration
stow -vv -d $(dirname "$0") -t $HOME config
# TODO: Have this persisted by a config file that will be symlinked rather than setting it by command.
gsettings set org.gnome.desktop.background picture-uri file:///$HOME/.background.jpg

# Enable Gnome
doas systemctl enable gdm
