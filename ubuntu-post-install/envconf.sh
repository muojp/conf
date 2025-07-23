# Change user password
echo "Please set a new password for user $(whoami):"
passwd

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts
npm install -g @anthropic-ai/claude-code
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

# GNOME Desktop Setup
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$XDG_CURRENT_DESKTOP" = "ubuntu:GNOME" ]; then
    echo "Running GNOME setup..."
    curl -L https://muojp.github.io/conf/gnome-setup.sh | bash
fi

# Firefox Bitwarden Extension Setup
echo "Setting up Firefox Bitwarden extension..."

# Create Firefox policies directory
sudo mkdir -p /etc/firefox/policies

# Create policies.json for Bitwarden auto-installation
sudo tee /etc/firefox/policies/policies.json > /dev/null << 'EOF'
{
  "policies": {
    "ExtensionSettings": {
      "{446900e4-71c2-419f-a6a7-df9c091e268b}": {
        "installation_mode": "normal_installed",
        "install_url": "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi"
      }
    }
  }
}
EOF

echo "Firefox Bitwarden policy configured. Extension will be available on next Firefox start."

# VSCode Installation
echo "Installing Visual Studio Code..."
curl -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /tmp/vscode.deb
sudo dpkg -i /tmp/vscode.deb
sudo apt-get install -f -y
rm /tmp/vscode.deb
echo "VSCode installed successfully"

# NoMachine Installation
echo "Installing NoMachine..."
curl -L "https://web9001.nomachine.com/download/9.0/Linux/nomachine_9.0.188_11_amd64.deb" -o /tmp/nomachine.deb
sudo dpkg -i /tmp/nomachine.deb
sudo apt-get install -f -y
rm /tmp/nomachine.deb
echo "NoMachine installed successfully"

