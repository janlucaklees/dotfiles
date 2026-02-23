#!/bin/bash

set -e
set -x

echo "Installing dependencies..."
doas pacman -S --needed --noconfirm pacman-contrib

echo "Updating mirrorlist..."
curl -fsSL "https://archlinux.org/mirrorlist/?country=DE&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - | doas tee /etc/pacman.d/mirrorlist
