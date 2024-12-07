#!/bin/bash

set -e
set -x

# Installing dependencies
yay -S --needed --noconfirm \
    zsh \
    oh-my-zsh-git \
    autojump \
    fzf \
    eza \
    bat \
    diff-so-fancy \
    ripgrep \
    noto-fonts-cjk \
    noto-fonts-emoji \
    noto-fonts

# Install Configuration
rm -f $HOME/.zshrc
stow -vv -d $(dirname "$0") -t $HOME config

# Set zsh as my default shell
chsh $USER -s /bin/zsh
