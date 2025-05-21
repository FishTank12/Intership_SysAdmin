#!/bin/bash

set -e 

echo [*]"Installing kate.."

echo [*] "Updating APT Packages.."
sudo apt update

echo [*] "Initiating Installation Protection Protocol.."
PACKAGE="kate"
MAX_RETRIES=3
DELAY=5
COUNT=1

while ! sudo apt install -y "$PACKAGE"; do
	echo "[-] Attempt $COUNT to  install $PACKAGE failed"

if ["$COUNT" -ge "$MAX_RETRIES"]; then
	echo "[-] Reached max retries ($MAX_RETRIES). Installation failed "
	exit 1
fi

COUNT=$((COUNT + 1))
echo "[*] Retrying in $DELAY seconds..."
sleep "$DELAY"
done

echo "[+] Kate installed successfully!"
