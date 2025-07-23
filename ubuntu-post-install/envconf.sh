#!/bin/bash

echo "=== Ubuntu Post-Install Configuration ==="

# Change user password
echo "=== Setting up user password ==="
echo "Please set a new password for user $(whoami):"
passwd

# Development Environment Setup
echo "=== Setting up development environment ==="
echo "Installing Node.js (nvm)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts
npm install -g @anthropic-ai/claude-code

echo "Installing Python package manager (uv)..."
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

echo "Development environment setup completed."

# GNOME Desktop Setup
if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$XDG_CURRENT_DESKTOP" = "ubuntu:GNOME" ]; then
    echo "=== Setting up GNOME desktop environment ==="
    curl -L https://muojp.github.io/conf/gnome-setup.sh | bash
    echo "GNOME setup completed."
fi

# Firefox Configuration
echo "=== Setting up Firefox ==="
echo "Configuring Firefox Bitwarden extension..."
sudo mkdir -p /etc/firefox/policies
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
echo "Firefox configuration completed."

# Application Installation
echo "=== Installing applications ==="

echo "Installing Visual Studio Code..."
curl -L "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -o /tmp/vscode.deb
sudo dpkg -i /tmp/vscode.deb
sudo apt-get install -f -y
rm /tmp/vscode.deb
echo "VSCode installed successfully"

echo "Installing NoMachine..."
curl -L "https://web9001.nomachine.com/download/9.0/Linux/nomachine_9.0.188_11_amd64.deb" -o /tmp/nomachine.deb
sudo dpkg -i /tmp/nomachine.deb
sudo apt-get install -f -y
rm /tmp/nomachine.deb
echo "NoMachine installed successfully"

# Power Management Configuration
echo "=== Configuring power management ==="
echo "Disabling suspend on lid close (ACPI mitigation)..."
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitchExternalPower=suspend/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/HandleLidSwitchExternalPower=suspend/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitchDocked=suspend/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
sudo sed -i 's/HandleLidSwitchDocked=suspend/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
echo "HandleLidSwitch=ignore" | sudo tee -a /etc/systemd/logind.conf
echo "HandleLidSwitchExternalPower=ignore" | sudo tee -a /etc/systemd/logind.conf
echo "HandleLidSwitchDocked=ignore" | sudo tee -a /etc/systemd/logind.conf
echo "Power management configured."

echo "=== Post-install configuration completed ==="
echo "Additional optional configurations available in /opt/post-install/:"
echo "- setup-autoshutdown.sh: Enable automatic shutdown on continuous lid close"
echo "- firefox-post-install.sh: Configure Firefox privacy settings"
echo "Please reboot the system to apply all changes."

