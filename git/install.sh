#!/usr/bin/env bash

# Install all configuration
stow -vv -d $(dirname "$0") -t $HOME config
