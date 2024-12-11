#!/bin/bash

set -e
set -x

# Installing dependencies
yay -S --needed --noconfirm \
    diff-so-fancy

# Setup SSH key
ssh-keygen -t ed25519 -a 100 -C "email@janlucaklees.de"
echo "Add this key to GitHub"
cat $HOME/.ssh/id_ed25519.pub

# Setup Configuration
## Name and Email
git config --global user.name "Jan-Luca Klees"
git config --global user.email "email@janlucaklees.de"
## Behavior
git config --global init.defaultBranch "master"
git config --global pull.rebase false
## Set editor
git config --global core.editor "nvim"
## Enable diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RF"
git config --global interactive.diffFilter "diff-so-fancy --patch"
## Optimize colors as suggested by diff-so-fancy
git config --global color.ui true
git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"
git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.func       "146 bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"
