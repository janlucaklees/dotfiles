#!/usr/bin/env bash

# Installing all zsh related stuff
yay -S --needed --noconfirm stow zsh oh-my-zsh-git autojump fzf eza bat icdiff ripgrep noto-fonts-cjk noto-fonts-emoji noto-fonts

# Install all configuration
stow -vv -d $(dirname "$0") -t $HOME config

# Set zsh as my default shell
chsh $USER -s /bin/zsh
