#!/bin/bash

set -e
set -x

echo "Installing dependencies..."
doas pacman -S --needed --noconfirm fakeroot

echo "Installing yay..."
rm -rf yay-bin
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
cd ..
rm -rf yay-bin

echo "Doing some after care..."
echo "This should only be run once!"
yay -Y --gendb
yay -Syu --devel
yay -Y --devel --save

source ./update-mirrors.sh
