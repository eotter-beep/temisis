#!/bin/bash
echo "Installing Temisis..."
sudo apt update
sudo apt install git make g++ libfreetype6-dev libx11-dev \
libxinerama-dev libxrandr-dev libxcursor-dev \
libxcomposite-dev mesa-common-dev freeglut3-dev \
libasound2-dev libjack-dev libc++-dev

echo "Installing Surge XT synthesizer..."
if ! dpkg -l | grep -q surge-xt; then
    curl -O https://github.com/surge-synthesizer/releases-xt/releases/download/1.3.4/surge-xt-linux-x64-1.3.4.deb
    sudo apt install ./surge-xt-linux-x64-1.3.4.deb
else
    echo "✓ Surge XT already installed, skipping..."
fi

echo "Installing BitKlavier piano..."
if ! dpkg -l | grep -q bitklavier; then
    echo 'deb http://download.opensuse.org/repositories/home:/c71b67b6:/fa2aa07a05c1/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/home:c71b67b6:fa2aa07a05c1.list
    curl -fsSL https://download.opensuse.org/repositories/home:c71b67b6:fa2aa07a05c1/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_c71b67b6_fa2aa07a05c1.gpg > /dev/null
    sudo apt update
    sudo apt install bitklavier
else
    echo "✓ BitKlavier already installed, skipping..."
fi

echo "Installing LSP Plugins FX suite..."
if ! dpkg -l | grep -q lsp-plugins; then
    sudo apt install lsp-plugins
else
    echo "✓ LSP Plugins already installed, skipping..."
fi

echo "Installing Hydrogen drum machine..."
if ! dpkg -l | grep -q hydrogen; then
    sudo apt install hydrogen
else
    echo "✓ Hydrogen already installed, skipping..."
fi

echo "Checking plugins are installed correctly..."
dpkg -l | grep -q surge-xt && echo "✓ Surge XT found" || echo "✗ Surge XT missing - please reinstall manually"
dpkg -l | grep -q bitklavier && echo "✓ BitKlavier found" || echo "✗ BitKlavier missing - please reinstall manually"
dpkg -l | grep -q lsp-plugins && echo "✓ LSP Plugins found" || echo "✗ LSP Plugins missing - please reinstall manually"
dpkg -l | grep -q hydrogen && echo "✓ Hydrogen found" || echo "✗ Hydrogen missing - please reinstall manually"

echo "Building Temisis..."
cd Projects/LinuxMakefile
export CONFIG=Release64
make

echo "Done! Open Temisis and run 'Scan VST3 Plugins' to make sure all instruments are detected."
echo "For help using Temisis, check the Helio docs at: https://helio.fm/documentation"
echo "To open Temisis, open it through this command, `./build/Helio_artefacts/Release/Standalone/Helio`"
