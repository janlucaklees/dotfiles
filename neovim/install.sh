#!/bin/bash

set -e
set -x

yay -S --needed --noconfirm \
	neovim

# Install Configuration
stow -vv -d $(dirname "$0") -t $HOME config

# Install nvim plugins
nvim +PlugInstall +qall