#!/bin/bash

LOCALDIR=$(dirname "$(realpath "$0")")
TOOLS_DIR="$LOCALDIR/tools"

# Ensure git is installed in Termux
pkg install git

# Move to the directory containing tools
cd "$TOOLS_DIR" || exit

# Initialize and update submodules
git submodule update --init --recursive
git pull --recurse-submodules

if [[ -d "$TOOLS_DIR/Firmware_extractor" ]]; then
    # Fetch the latest changes and reset to origin/master
    git -C "$TOOLS_DIR/Firmware_extractor" fetch origin
    git -C "$TOOLS_DIR/Firmware_extractor" reset --hard origin/master
else
    # Clone the repository if it doesn't exist
    git clone -q https://github.com/meleksaidani1/Firmware_extractor "$TOOLS_DIR"/Firmware_extractor
fi
