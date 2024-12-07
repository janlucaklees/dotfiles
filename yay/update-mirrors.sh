#!/bin/bash

set -e
set -x

echo "Installing dependencies..."
doas pacman -S --needed --noconfirm pacman-contrib

echo "Updating mirrorlist..."
curl -s "https://archlinux.org/mirrorlist/?country=DE&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | doas rankmirrors -n 5 - > /etc/pacman.d/mirrorlist
