#!/bin/bash

# Ensure the script is run with sudo
if [[ $EUID -ne 0 ]]; then
   echo "[!] This script must be run as root (sudo)." 
   exit 1
fi

# Function to check Docker version and install if missing
check_docker_version() {
    if ! command -v docker &>/dev/null; then
        echo "[!] Docker is not installed."
        read -p "Install Docker now? [y/n]: " install_docker
        if [[ "$install_docker" == "y" ]]; then
            echo "[*] Installing Docker..."
            curl -fsSL https://get.docker.com | sh
        else
            echo "[!] Docker is required. Exiting."
            exit 1
        fi
    fi

    DOCKER_MAJOR=$(docker version --format '{{.Server.Version}}' | cut -d. -f1)
    echo "[*] Docker major version: $DOCKER_MAJOR"

    if [[ -z "$DOCKER_MAJOR" || "$DOCKER_MAJOR" -lt 20 ]]; then
        echo "[!] Docker version < 20. Updating..."
        curl -fsSL https://get.docker.com | sh
    else
        echo "[+] Docker version is sufficient."
    fi
}

# Function to check and install make/build tools
check_build_tools() {
    if ! command -v make &>/dev/null; then
        echo "[!] 'make' not found. Installing build-essential..."
        apt update && apt install -y build-essential
    else
        echo "[+] 'make' is already installed."
    fi
}

# Main installation
main() {
    check_docker_version
    check_build_tools

    INSTALL_DIR="/opt/docker/mythic"

    echo "[*] Preparing Mythic directory at $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"

    if [[ ! -w "$INSTALL_DIR" ]]; then
        echo "[!] No write permissions to $INSTALL_DIR. Please check ownership or permissions."
        exit 1
    fi

    cd "$INSTALL_DIR" || exit 1

    if [[ ! -d mythic ]]; then
        echo "[*] Cloning Mythic repository..."
        git clone https://github.com/its-a-feature/Mythic mythic --depth 1
    else
        echo "[+] Mythic repository already exists."
    fi

    cd mythic || exit 1

    echo "[*] Building mythic-cli..."
    make

    echo "[*] Starting Mythic services..."
    ./mythic-cli start

    echo ""
    echo "[+] Mythic installation and startup complete."
    echo "[*] Access Mythic in your browser at: http://localhost:7443"
    echo "[!] Default credentials:"
    echo "    Username: mythic_admin"
    echo "    Password: mythic_password"
}

main
