!#/bash/bin

#!/bin/bash

# Step 1: Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Step 2: Install wget if not already installed
echo "Installing wget..."
sudo apt install wget -y

# Step 3: Check if the Downloads directory exists
if [ ! -d "$HOME/Downloads" ]; then
    echo "Downloads directory does not exist. Creating it..."
    mkdir -p "$HOME/Downloads"
fi
cd "$HOME/Downloads"

# Step 4: Download Google Chrome .deb package
echo "Downloading Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# Step 5: Install the downloaded package
echo "Installing Google Chrome..."
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Step 6: Fix any missing dependencies
echo "Fixing missing dependencies..."
sudo apt --fix-broken install -y

# Step 7: Clean up downloaded package
echo "Cleaning up..."
rm google-chrome-stable_current_amd64.deb

# Step 8: Launch Google Chrome
echo "Launching Google Chrome..."
google-chrome-stable

