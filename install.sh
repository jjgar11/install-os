#!/bin/bash

# Update system packages
sudo apt update && sudo apt full-upgrade -y

# Install essential packages
sudo apt install -y build-essential \\
    neovim nano bat gedit curl git wget gpg net-tools unzip \\
    neofetch \\
    python3 python3-venv 

mkdir -p ~/.local/bin && ln -s /usr/bin/batcat ~/.local/bin/bat

wget -q https://github.com/dylanaraps/pfetch/archive/master.zip -O /tmp/master.zip
unzip -q /tmp/master.zip -d /tmp/pfetch-master
sudo install /tmp/pfetch-master/pfetch-master/pfetch /usr/local/bin/
rm -rf /tmp/master.zip /tmp/pfetch-master


mkdir -p ~/.config/nvim && cp ~/.install/files/.vimrc ~/.config/nvim/init.nvim

# Configure ssh keys for different purposes
keys=("devices" "personal_repos" "spc_repos" "spc_vpn")

for key in "${keys[@]}"; do
    ssh-keygen -N "" -f ~/.ssh/id_rsa_$key -C "$(whoami)@$(hostname)_for_$key"
done
# ssh-keygen -p -f ~/.ssh/id_rsa        For changing passphrase
cp ~/.install/files/ssh-config ~/.ssh/

# Change shell from bash to zsh with oh-my-zsh
sudo apt install zsh
chsh -s $(which zsh)

mv ~/.zshrc ~/.zshrc-orig
(echo "# User specific definitions\nif [ -f ~/.rc.d/init.rc ]; then\n    source ~/.rc.d/init.rc\nfi\n\n"; cat ~/.zshrc-orig) >  ~/.zshrc
apt_pref='apt' && apt_upgr='upgrade'
sed -i 's/plugins=(git)/plugins=(git z zsh-syntax-highlighting python debian)/' ~/.zshrc

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cp ~/.install/files/.p10k.zsh ~/

source ~/.zshrc

# Change login manager to lightdm
sudo apt install lightdm && sudo dpkg-reconfigure -f noninteractive lightdm