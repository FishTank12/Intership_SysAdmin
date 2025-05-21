#!/bin/bash

echo "[*]  Installing CherryTree..."

PACKAGE_NAME="cherrytree"
MAX_RETRIES=3
DELAY=5
COUNT=1

echo "[*] Updating APT packages.."

sudo apt update

while ! sudo apt install -y "$PACKAGE_NAME"; do
    echo "[-] Attempt $COUNT to install $PACKAGE_NAME failed.."

    if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
    echo "[-] Reached max retries ($MAX_RETRIES). Installation failed.."
    exit 1

    fi

     COUNT=$((COUNT + 1))
    echo "[*] Retrying in $DELAY seconds..."
    sleep "$DELAY"
done

echo "[+] CherryTree installed successfully!"
