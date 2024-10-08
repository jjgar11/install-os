#!/bin/bash

# Update system packages
sudo apt update && sudo apt full-upgrade -y

# Install essential packages
sudo apt install -y build-essential \
    nano bat gedit curl git wget gpg net-tools unzip \
    neofetch \
    python3 \
    make libssl-dev zlib1g-dev \
    nlibbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev \
    nlibncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl

# Install pyenv and virtualenvwrapper
curl https://pyenv.run | bash
git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git $(pyenv root)/plugins/pyenv-virtualenvwrapper

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

# Configure ssh keys for different purposes
keys=("devices" "personal_repos" "spc_repos" "spc_vpn")

for key in "${keys[@]}"; do
    ssh-keygen -N "" -f ~/.ssh/id_rsa_$key -C "$(whoami)@$(hostname)_for_$key"
done
# ssh-keygen -p -f ~/.ssh/id_rsa        For changing passphrase
cp ~/.install/files/ssh-config ~/.ssh/config

# Change shell from bash to zsh with oh-my-zsh
sudo apt install -y zsh
echo 'Y' | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mv ~/.zshrc ~/.zshrc-orig
cp -r ~/.install/files/.rc.d/ ~/.rc.d/
(cat .install/files/zsh_start; cat ~/.zshrc-orig) >  ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
apt_pref='apt' && apt_upgr='upgrade'
sed -i 's/plugins=(git)/plugins=(git z zsh-syntax-highlighting python debian history)/' ~/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc

chsh -s $(which zsh)

# Change login manager to lightdm
sudo apt install -y lightdm && sudo dpkg-reconfigure -f noninteractive lightdm
