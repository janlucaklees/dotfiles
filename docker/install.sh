#!/bin/bash

set -e
set -x

# Installing dependencies
yay -S --needed --noconfirm \
    docker \
    docker-compose

# Adding myself to the docker group, creating the group if it does not exist
getent group docker || doas groupadd docker
doas usermod -a -G docker "${USER}"

# Start the service
systemctl enable --now docker.socket
