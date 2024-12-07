#!/bin/bash

set -e
set -x

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
