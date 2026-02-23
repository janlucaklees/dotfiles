#!/usr/bin/env bash

set -euo pipefail
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
rm -f $HOME/.bashrc
rm -f $HOME/.bash_login
rm -f $HOME/.bash_logout
rm -f $HOME/.bash_profile
rm -f $HOME/.bash_history
stow -vv -d $(dirname "$0") -t $HOME config

# Set zsh as my default shell
chsh $USER -s /bin/zsh
