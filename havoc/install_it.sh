#!/bin/bash

# HAVOC INSTALLATION SCRIPT

# STEP 1: Clone the Havoc repository
echo "[*] Cloning Havoc Framework..."
git clone https://github.com/HavocFramework/Havoc.git || { echo "[!] Git clone failed."; exit 1; }

# STEP 2: Install dependencies
echo "[*] Installing dependencies..."
sudo apt update
sudo apt install -y git build-essential apt-utils cmake libfontconfig1 libglu1-mesa-dev libgtest-dev \
libspdlog-dev libboost-all-dev libncurses5-dev libgdbm-dev libssl-dev libreadline-dev libffi-dev \
libsqlite3-dev libbz2-dev mesa-common-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
libqt5websockets5 libqt5websockets5-dev qtdeclarative5-dev golang-go python3-dev mingw-w64 nasm || {
    echo "[!] Failed to install dependencies."
    exit 1
}

# STEP 3: Navigate to the teamserver directory
cd Havoc/teamserver || { echo "[!] Cannot find teamserver directory."; exit 1; }

# STEP 4: Run the Install.sh script
echo "[*] Running Install.sh..."
chmod +x Install.sh
./Install.sh || { echo "[!] Install.sh failed."; exit 1; }

# STEP 5: Download necessary Go modules
echo "[*] Downloading Go modules..."
go mod download golang.org/x/sys || echo "[!] Warning: Failed to download golang.org/x/sys"
go mod download github.com/ugorji/go || echo "[!] Warning: Failed to download github.com/ugorji/go"

# STEP 6: Go back to the main Havoc directory
cd ..

# STEP 7: Compile the teamserver
echo "[*] Compiling the teamserver..."
make ts-build || { echo "[!] Failed to build teamserver."; exit 1; }

# STEP 8: Start the teamserver
echo "[*] Starting teamserver..."
./havoc server --profile ./profiles/havoc.yaotl -v --debug &

# STEP 9: Compile the client
echo "[*] Compiling the client..."
make client-build || { echo "[!] Failed to build client."; exit 1; }

# STEP 10: Run the client
echo "[*] Running the client..."
./havoc client &

# STEP 11: Display the profile file with credentials
echo "[*] Displaying user and password from profile..."
cat profiles/havoc.yaotl | grep -Ei 'user|pass'

echo "[*] Installation and setup complete."
