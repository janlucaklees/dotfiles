#!/bin/bash

set -x
set -e

echo "Installing dependencies..."
doas pacman -S --needed --noconfirm fakeroot

echo "Installing yay..."
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

echo "Doing some after care..."
yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save

echo "Updating mirrorlist..."
curl -s "https://archlinux.org/mirrorlist/?country=DE&protocol=https&use_mirror_status=on" | sed -e 's/^#Server/Server/' -e '/^#/d' | rankmirrors -n 5 - > /etc/pacman.d/mirrorlist
