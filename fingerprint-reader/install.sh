#!/bin/bash

set -e
set -x

# Installing dependencies
yay -S --needed --noconfirm \
    fprintd 

# Add myself to the input group to ensure I can access the reader.
doas usermod -a -G input $USER
