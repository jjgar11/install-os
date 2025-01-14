#!/bin/bash

# Link batcat to bat
mkdir -p ~/.local/bin && ln -s /usr/bin/batcat ~/.local/bin/bat

# Install pfetch
wget -q https://github.com/dylanaraps/pfetch/archive/master.zip -O /tmp/master.zip
unzip -q /tmp/master.zip -d /tmp/pfetch-master
sudo install /tmp/pfetch-master/pfetch-master/pfetch /usr/local/bin/
rm -rf /tmp/master.zip /tmp/pfetch-master

# Install and link neovim
wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x ./nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim
ln -s /usr/local/bin/nvim ~/.local/bin/vim
# Configure neovim
mkdir -p ~/.config/nvim && cp ~/.install/files/init.vim ~/.config/nvim/init.nvim
