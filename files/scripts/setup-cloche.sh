#!/usr/bin/env bash
set -eoux pipefail

echo "Cloche Setup"
# 
echo "Fastfetch"

if [ -f /etc/skel/.bashrc ]; then
    sed -i '/alias fastfetch/d' /etc/skel/.bashrc
fi

if [ -f /etc/skel/.zshrc ]; then
    sed -i '/alias fastfetch/d' /etc/skel/.zshrc
fi
plymouth-set-default-theme spinner
echo "Finished"