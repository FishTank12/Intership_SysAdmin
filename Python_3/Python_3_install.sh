#!/bin/bash

echo "[*] Installing Python3 via Deadsnakes PPA..."

PACKAGE_NAME="software-properties-common"
PPA_NAME="ppa:deadsnakes/ppa"
PYTHON_VERSION="python3.12"   # Change this to whichever version you want to install
MAX_RETRIES=3
DELAY=5
COUNT=1

echo "[*] Updating APT packages..."
sudo apt update

# Retry installation of supporting package
while ! sudo apt install -y "$PACKAGE_NAME"; do
    echo "[-] Attempt $COUNT to install $PACKAGE_NAME failed."

    if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
        echo "[-] Reached max retries ($MAX_RETRIES). Installation failed."
        exit 1
    fi

    COUNT=$((COUNT + 1))
    echo "[*] Retrying in $DELAY seconds..."
    sleep "$DELAY"
done

echo "[+] $PACKAGE_NAME installed successfully."

# Add Deadsnakes PPA
echo "[*] Adding Deadsnakes PPA..."
sudo add-apt-repository -y "$PPA_NAME"
if [ $? -ne 0 ]; then
    echo "[-] Failed to add Deadsnakes PPA."
    exit 1
fi

echo "[*] Updating APT packages after adding PPA..."
sudo apt update

# Reset retry count for Python install
COUNT=1

# Retry installing Python version
while ! sudo apt install -y "$PYTHON_VERSION"; do
    echo "[-] Attempt $COUNT to install $PYTHON_VERSION failed."

    if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
        echo "[-] Reached max retries ($MAX_RETRIES). Installation failed."
        exit 1
    fi

    COUNT=$((COUNT + 1))
    echo "[*] Retrying in $DELAY seconds..."
    sleep "$DELAY"
done

echo "[+] $PYTHON_VERSION installed successfully!"

# Verify installation
python3 --version
