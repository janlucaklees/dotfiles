#!/bin/bash

set -e
set -x

# Installing dependencies
yay -S --needed --noconfirm \
    fw-ectool-git \
    framework-laptop-kmod-dkms-git \
    framework-system-git \
    polkit