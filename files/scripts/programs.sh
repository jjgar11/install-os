#!/bin/bash


# Add VS Code repository and install
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
sudo apt install apt-transport-https
sudo apt update
sudo apt install code


# Add Vivaldi repository and install
wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo dd of=/etc/apt/keyrings/vivaldi-browser.gpg
echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" | sudo dd of=/etc/apt/sources.list.d/vivaldi-archive.list
sudo apt update
sudo apt install vivaldi-stable


# Add Spotify repository and install
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/keyrings/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt update
sudo apt install spotify-client


# Install Alacritty terminal emulator

# Install Rust and other dependencies
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup override set stable
rustup update stable
sudo apt install cmake g++ pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 sdoc gzip
# Clone the Alacritty repository and build
ALACRITTY_TEMP_DIR=$(mktemp -d)
git clone https://github.com/alacritty/alacritty.git "$ALACRITTY_TEMP_DIR"
cd "$ALACRITTY_TEMP_DIR"
# Build and post-installation steps
cargo build --release
# Terminfo
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
# Desktop entry
sudo cp "$ALACRITTY_TEMP_DIR/target/release/alacritty" /usr/local/bin
sudo cp "$ALACRITTY_TEMP_DIR/extra/logo/alacritty-term.svg" /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install "$ALACRITTY_TEMP_DIR/extra/linux/Alacritty.desktop"
sudo update-desktop-database
# Manual pages
sudo mkdir -p /usr/local/share/man/man1
sudo mkdir -p /usr/local/share/man/man5
scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null
# Zsh shell completion
mkdir -p ${ZDOTDIR:-~}/.zsh_functions
echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc
cp "$ALACRITTY_TEMP_DIR/extra/completions/_alacritty" ${ZDOTDIR:-~}/.zsh_functions/_alacritty
rm -rf "$ALACRITTY_TEMP_DIR"
# Configuration file and themes
ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"
mkdir -p "$ALACRITTY_CONFIG_DIR/themes"
git clone https://github.com/alacritty/alacritty-theme "$ALACRITTY_CONFIG_DIR/themes"
cp "$HOME/install-os/files/config/alacritty.toml" "$ALACRITTY_CONFIG_DIR/alacritty.toml"