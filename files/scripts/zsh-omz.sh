#!/bin/bash

# Exit on any error or unset variable, and treat errors in pipelines properly
set -euo pipefail

# Install zsh if not already installed
echo "Installing zsh..."
if ! command -v zsh &> /dev/null; then
    sudo apt update && sudo apt install -y zsh
else
    echo "zsh is already installed."
fi

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "Oh My Zsh is already installed. Skipping installation."
else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Backup existing .zshrc if present
ZSHRC_ORIG="$HOME/.zshrc-orig"
if [[ -f "$HOME/.zshrc" && ! -f "$ZSHRC_ORIG" ]]; then
    echo "Backing up existing .zshrc to $ZSHRC_ORIG..."
    mv "$HOME/.zshrc" "$ZSHRC_ORIG"
fi

# Copy custom configurations
echo "Copying custom Zsh configurations..."
RC_D_SOURCE="$HOME/install-os/files/.rc.d"
RC_D_TARGET="$HOME/.rc.d"
if [[ -d "$RC_D_SOURCE" ]]; then
    # Copy files while overwriting and setting permissions
    cp -rT "$RC_D_SOURCE" "$RC_D_TARGET"

    # Set the copied files to read-only (only the user can edit custom configurations)
    find "$RC_D_TARGET" -type f -exec chmod 444 {} \;

    # Create a separate file for user customizations that will not be overwritten
    # USER_CONFIG_FILE="$RC_D_TARGET/user_customizations.conf"
    # if [ ! -f "$USER_CONFIG_FILE" ]; then
    #     touch "$USER_CONFIG_FILE"
    #     chmod 644 "$USER_CONFIG_FILE"  # Allow the user to edit it
    #     echo "# Place your custom configurations in this file." > "$USER_CONFIG_FILE"
    # fi
else
    echo "Error: Source directory $RC_D_SOURCE does not exist."
    exit 1
fi

# Ensure zsh_start file exists before trying to copy
ZSH_START_FILE="$HOME/install-os/files/zsh_start"
if [[ -f "$ZSH_START_FILE" ]]; then
    cat "$ZSH_START_FILE" "$ZSHRC_ORIG" > "$HOME/.zshrc"
else
    echo "Error: Custom Zsh start file $ZSH_START_FILE not found."
    exit 1
fi

# Install and configure plugins and themes
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

echo "Installing zsh-syntax-highlighting plugin..."
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting plugin is already installed."
fi

echo "Checking if Powerlevel10k is installed..."
if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
    echo "Powerlevel10k theme is not installed. Installing..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "Powerlevel10k theme is already installed. Skipping installation."
fi

# Update .zshrc with custom plugins and theme
echo "Updating .zshrc with custom plugins and theme..."
sed -i 's|^plugins=(.*)|plugins=(git z zsh-syntax-highlighting python debian history)|' "$HOME/.zshrc"
sed -i 's|^ZSH_THEME=".*"|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$HOME/.zshrc"

# Change default shell to zsh
echo "Changing the default shell to zsh..."
CURRENT_SHELL=$(getent passwd "$(whoami)" | cut -d: -f7)
if [[ "$CURRENT_SHELL" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)"
    echo "Default shell changed to zsh. You need to log out and log back in for the change to take effect."
else
    echo "zsh is already set as the default shell."
fi

echo "Zsh and Oh My Zsh setup completed successfully!"
