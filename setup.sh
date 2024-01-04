#!/bin/bash

if [[ "$(uname)" == "Linux" ]]; then
    if [[ -n "$(command -v pkg)" ]]; then
        pkg update && pkg upgrade pkg install python git coreutils pkg install -y unace unrar zip unzip p7zip p7zip-plugins sharutils uudeview arj file dtc python brotli lz4 gawk aria2 pkg install tsu
        # Adjust installation commands based on what's available in Termux packages
    else
        echo "Please install 'pkg' package manager in Termux."
        exit 1
    fi
    pip install backports.lzma protobuf pycryptodome
elif [[ "$(uname)" == "Darwin" ]]; then
    echo "This script is not designed for macOS."
    exit 1
else
    echo "Unsupported operating system."
    exit 1
fi
