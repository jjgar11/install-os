#!/bin/bash

# Exit on any error or unset variable, and treat errors in pipelines properly
set -euo pipefail

# Función para instalar repositorios y claves
install_repo() {
  local key_url="$1"
  local key_path="$2"
  local repo_entry="$3"
  local repo_list="$4"

  wget -qO- "$key_url" | gpg --dearmor | sudo tee "$key_path" > /dev/null
  echo "$repo_entry" | sudo tee "$repo_list" > /dev/null
}

# Add VS Code repository and install
echo "Installing Visual Studio Code..."
sudo apt-get install -y wget gpg
install_repo \
  "https://packages.microsoft.com/keys/microsoft.asc" \
  "/etc/apt/keyrings/packages.microsoft.gpg" \
  "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
  "/etc/apt/sources.list.d/vscode.list"


# Add Vivaldi repository and install
echo "Installing Vivaldi..."
install_repo \
  "https://repo.vivaldi.com/archive/linux_signing_key.pub" \
  "/etc/apt/keyrings/vivaldi-browser.gpg" \
  "deb [signed-by=/etc/apt/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" \
  "/etc/apt/sources.list.d/vivaldi-archive.list"


# Add Spotify repository and install
echo "Installing Spotify..."
install_repo \
  "https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg" \
  "/etc/apt/keyrings/spotify.gpg" \
  "deb [signed-by=/etc/apt/keyrings/spotify.gpg] http://repository.spotify.com stable non-free" \
  "/etc/apt/sources.list.d/spotify.list"
sudo apt-get update
sudo apt-get install -y code vivaldi-stable spotify-client

# Install Alacritty terminal emulator
echo "Installing Alacritty..."

# Install Rust and other dependencies
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup override set stable
rustup update stable
sudo apt-get install -y cmake g++ pkg-config libfreetype6-dev libfontconfig1-dev \
  libxcb-xfixes0-dev libxkbcommon-dev python3 scdoc gzip

# Clone Alacritty and build
ALACRITTY_TEMP_DIR=$(mktemp -d)
git clone https://github.com/alacritty/alacritty.git "$ALACRITTY_TEMP_DIR"
pushd "$ALACRITTY_TEMP_DIR"
cargo build --release

# Terminfo
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

# Desktop entry
sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

# Manual pages
sudo mkdir -p /usr/local/share/man/man1
sudo mkdir -p /usr/local/share/man/man5
scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null

# Zsh shell completion
mkdir -p "${ZDOTDIR:-$HOME}/.zsh_functions"
echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> "${ZDOTDIR:-$HOME}/.zshrc"
cp extra/completions/_alacritty "${ZDOTDIR:-$HOME}/.zsh_functions/_alacritty"
popd
rm -rf "$ALACRITTY_TEMP_DIR"

# Configuration file and themes
ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"
mkdir -p "$ALACRITTY_CONFIG_DIR/themes"
git clone https://github.com/alacritty/alacritty-theme "$ALACRITTY_CONFIG_DIR/themes"
cp "$HOME/install-os/files/config/alacritty.toml" "$ALACRITTY_CONFIG_DIR/alacritty.toml"


echo "Instalación completada."
