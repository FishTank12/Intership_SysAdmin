
#!/bin/bash

set -e

VECTR_VERSION="9.7.0"
VECTR_DIR="/opt/vectr"
VECTR_ZIP="sra-vectr-runtime-${VECTR_VERSION}-ce.zip"
VECTR_URL="https://github.com/SecurityRiskAdvisors/VECTR/releases/download/ce-${VECTR_VERSION}/${VECTR_ZIP}"
HOSTNAME_VALUE="0.0.0.0"

echo "[*] Updating packages..."
sudo apt-get update -y

echo "[*] Installing dependencies..."
sudo apt-get install -y ca-certificates curl unzip wget gnupg lsb-release

echo "[*] Setting up Docker repo..."
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "[*] Adding Docker apt source..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[*] Installing Docker components..."
sudo apt-get update -y
sudo apt-get install -y
