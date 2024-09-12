#!/bin/bash

# Update system packages
sudo apt update && sudo apt full-upgrade -y

# Install essential packages
sudo apt install -y build-essential \
    neovim nano bat gedit curl git wget gpg net-tools unzip \
    neofetch \
    python3 python3-venv

mkdir -p ~/.local/bin && ln -s /usr/bin/batcat ~/.local/bin/bat

wget -q https://github.com/dylanaraps/pfetch/archive/master.zip -O /tmp/master.zip
unzip -q /tmp/master.zip -d /tmp/pfetch-master
sudo install /tmp/pfetch-master/pfetch-master/pfetch /usr/local/bin/
rm -rf /tmp/master.zip /tmp/pfetch-master


mkdir -p ~/.config/nvim && cp ~/.install/files/vimrc ~/.config/nvim/init.nvim

# Configure ssh keys for different purposes
keys=("devices" "personal_repos" "spc_repos" "spc_vpn")

for key in "${keys[@]}"; do
    ssh-keygen -N "" -f ~/.ssh/id_rsa_$key -C "$(whoami)@$(hostname)_for_$key"
done
# ssh-keygen -p -f ~/.ssh/id_rsa        For changing passphrase
cp ~/.install/files/ssh-config ~/.ssh/config

# Change shell from bash to zsh with oh-my-zsh
sudo apt install -y zsh
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mv ~/.zshrc ~/.zshrc-orig
(cat .install/files/zsh_start; cat ~/.zshrc-orig) >  ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
apt_pref='apt' && apt_upgr='upgrade'
sed -i 's/plugins=(git)/plugins=(git z zsh-syntax-highlighting python debian)/' ~/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k/powerlevel10k"/'
cp ~/.install/files/p10k.zsh ~/.p10k.zsh

chsh -s $(which zsh)

# Change login manager to lightdm
sudo apt install lightdm && sudo dpkg-reconfigure -f noninteractive lightdm