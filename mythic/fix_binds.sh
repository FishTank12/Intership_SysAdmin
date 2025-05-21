#!/bin/bash

MYTHIC_DIR="/opt/docker/mythic/mythic-docker"
COMPOSE_FILE="$MYTHIC_DIR/docker-compose.yml"

if [[ ! -f "$COMPOSE_FILE" ]]; then
    echo "[!] Could not find docker-compose.yml at $COMPOSE_FILE"
    exit 1
fi

echo "[*] Backing up existing docker-compose.yml to docker-compose.yml.bak"
cp "$COMPOSE_FILE" "${COMPOSE_FILE}.bak"

echo "[*] Updating port bindings to avoid conflicts..."

# Rebind mythic_nginx 7443 -> 8443
sed -i 's/- "7443:7443"/- "8443:7443"/g' "$COMPOSE_FILE"

# Rebind mythic_server 17443 -> 18443
sed -i 's/- "17443:17443"/- "18443:17443"/g' "$COMPOSE_FILE"

# Optional: Rebind other exposed ports if needed (add more sed lines)

echo "[+] Port bindings updated successfully."
echo "[*] Restarting Mythic services..."

cd "$MYTHIC_DIR"
sudo ./mythic-cli restart

echo "[+] Mythic should now be accessible at: https://localhost:8443"
