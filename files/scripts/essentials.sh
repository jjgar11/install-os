#!/bin/bash

# Update system packages
sudo apt update && sudo apt full-upgrade -y

# Install essential packages
sudo apt install -y \
    build-essential \
    nano gedit curl git wget gpg net-tools unzip \
    neofetch \
    python3
sudo apt install -y \
    make libssl-dev zlib1g-dev \
    nlibbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev \
    nlibncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev \
    python3-openssl
