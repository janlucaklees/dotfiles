#!/usr/bin/env bash

# Set script to exit on error and treat unset variables as an error
set -euo pipefail

# Check if Walker is running
if pgrep -f "^walker$" > /dev/null; then
    pkill -f "^walker$"
else
    walker
fi
