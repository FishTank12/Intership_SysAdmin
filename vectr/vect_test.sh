
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
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "[*] Creating install directory $VECTR_DIR..."
sudo mkdir -p "$VECTR_DIR"
cd "$VECTR_DIR"

echo "[*] Downloading VECTR $VECTR_VERSION..."
wget -q --show-progress "$VECTR_URL"

echo "[*] Unzipping runtime package..."
unzip -o "$VECTR_ZIP"

echo "[*] Configuring .env file..."
sed -i "s/^VECTR_HOSTNAME=.*/VECTR_HOSTNAME=$HOSTNAME_VALUE/" .env
sed -i "s/^VECTR_HTTPS=.*/VECTR_HTTPS=false/" .env

echo "[*] Starting VECTR containers..."
sudo docker compose up -d

echo "VECTR is installed and running at: http://$HOSTNAME_VALUE:8081
