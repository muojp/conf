#!/bin/bash

echo "Setting up automatic shutdown on continuous lid close..."

# Create autoshutdown user and group
echo "Creating autoshutdown user and group..."
sudo groupadd -f autoshutdown
sudo useradd -r -g autoshutdown -s /bin/false autoshutdown 2>/dev/null || true

# Create directory structure
echo "Creating directory structure..."
sudo mkdir -p /opt/autoshutdown
sudo chown autoshutdown:autoshutdown /opt/autoshutdown

# Copy shutdown script
echo "Installing shutdown script..."
sudo cp shutdown-by-continuous-lid-close.sh /opt/autoshutdown/
sudo chown autoshutdown:root /opt/autoshutdown/shutdown-by-continuous-lid-close.sh
sudo chmod 755 /opt/autoshutdown/shutdown-by-continuous-lid-close.sh

# Initialize counter file
echo "Initializing counter file..."
sudo touch /opt/autoshutdown/closed_count
echo -n 0 | sudo tee /opt/autoshutdown/closed_count > /dev/null
sudo chown autoshutdown:autoshutdown /opt/autoshutdown/closed_count
sudo chmod 664 /opt/autoshutdown/closed_count

# Setup cron job for autoshutdown user
echo "Setting up cron job..."
echo "* * * * * /opt/autoshutdown/shutdown-by-continuous-lid-close.sh" | sudo crontab -u autoshutdown -

# Allow autoshutdown user to run poweroff without password
echo "Configuring sudo permissions..."
echo "autoshutdown ALL=(ALL) NOPASSWD: /sbin/poweroff" | sudo tee /etc/sudoers.d/autoshutdown > /dev/null
sudo chmod 440 /etc/sudoers.d/autoshutdown

echo "Autoshutdown setup completed successfully!"
echo "The system will now automatically shutdown after 30 minutes of continuous lid close with power disconnected."