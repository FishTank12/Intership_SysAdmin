#!/bin/bash

echo "[*] Installing Visual Studio Code..."

DEB_URL="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
DEB_PATH="/tmp/vscode_latest_amd64.deb"
MAX_RETRIES=3
DELAY=5
COUNT=1

echo "[*] Updating APT packages..."
sudo apt update

echo "[*] Downloading latest VS Code .deb from official site..."
wget -O "$DEB_PATH" "$DEB_URL"
if [ $? -ne 0 ]; then
    echo "[-] Failed to download VS Code installer."
    exit 1
fi

# Retry logic
while ! sudo apt install -y "$DEB_PATH"; do
    echo "[-] Attempt $COUNT to install VS Code failed."

    if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
        echo "[-] Reached max retries ($MAX_RETRIES). Trying fallback method using dpkg..."

        sudo dpkg -i "$DEB_PATH"
        sudo apt-get install -f -y

        if [ $? -eq 0 ]; then
            echo "[+] VS Code installed successfully via fallback method!"
            exit 0
        else
            echo "[-] VS Code installation failed completely."
            exit 1
        fi
    fi

    COUNT=$((COUNT + 1))
    echo "[*] Retrying in $DELAY seconds..."
    sleep "$DELAY"
done

echo "[+] VS Code installed successfully!"
