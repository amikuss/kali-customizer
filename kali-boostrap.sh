#!/usr/bin/env bash
set -e

git clone git@github.com:amikuss/kali-customizer.git
cd kali-customizer
WD=$(pwd)

echo "[+] Starting Kali bootstrap..."

############################
# 0. Basic preparation
############################

sudo apt update
sudo apt install -y curl wget git gnupg lsb-release python3-pip pipx

pipx ensurepath

############################
# 1. Install Docker CE
############################

echo "[+] Installing Docker..."

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian trixie stable" |
    sudo tee /etc/apt/sources.list.d/docker.list

curl -fsSL https://download.docker.com/linux/debian/gpg |
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $USER

echo "[+] Docker installed:"
echo "$(docker --version)"
echo "$(docker compose version)"

############################
# 2. Setup .zshrc
############################

echo "[+] Installing custom .zshrc..."

if [ -f "./files/kali-zshrc" ]; then
    cp ./files/kali-zshrc ~/.zshrc
else
    echo "[!] kali-zshrc not found in current directory"
fi

############################
# 3. Install Exegol
############################

echo "[+] Installing Exegol..."

pipx install exegol || true

echo "alias exegol='sudo -E ~/.local/bin/exegol'" >>~/.zshrc

# Non-interactive install (auto-yes)
exegol install free --accept-eula

############################
# 4. Install BloodHound CE
############################

echo "[+] Installing BloodHound CLI..."

mkdir ~/BloodHound
cd ~/BloodHound

wget -q https://github.com/SpecterOps/bloodhound-cli/releases/latest/download/bloodhound-cli-linux-amd64.tar.gz
tar -xzf bloodhound-cli-linux-amd64.tar.gz
./bloodhound-cli install

############################
# 5. Install RustHound CE
############################

echo "[+] Building RustHound-CE..."

cd
git clone https://github.com/g0h4n/RustHound-CE.git || true
cd RustHound-CE

docker build --rm -t rusthound-ce .
docker run --rm -v $PWD:/usr/src/rusthound-ce rusthound-ce release

############################
# 6. Install and config nvim
############################

echo "[+] Installing nvim"
cd $WD
cp -r ./configs/nvim ~/.config/

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin' >>~/.zshrc

nvim --headless "+Lazy! restore" +qa

############################
# 6. Install obisidna
############################

echo "[+] Installing obsidian"

wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.11.7/obsidian_1.11.7_amd64.deb -O ~/Downloads/obsidian_1.11.7_amd64.deb
sudo dpkg -i ~/Downloads/obsidian_1.11.7_amd64.deb

mkdir -p ~/vault
mkdir -p ~/vault/.obsidian

############################
# 6. TMUX conf
############################

echo "[+] Configuring TMUX"
cp ./configs/tmux.conf ~/.tmux.conf

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
