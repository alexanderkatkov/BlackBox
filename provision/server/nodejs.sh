#!/usr/bin/env bash
#
# Node.js provision file
echo ">>> Node.js installation & configuration"

# Node.js package provision
echo "==> Checking if Node.js is installed..."
if type node &> /dev/null
then
echo "==> Node.js already installed!"
else
echo "==> Download installer & performing install..."
# Download installation
sudo curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
# Installing Node.js package
sudo apt-get -y install nodejs
sudo ln -s /usr/bin/nodejs /usr/bin/node

echo "==> Update NPM..."
# Updating NPM package manager
sudo npm install npm@latest -g

# Allow npm to fully work without sudo
echo "==> Configuring NPM permissions..."
# Make a directory for global installations
mkdir ~/.npm-global
# Configure npm to use the new directory path
npm config set prefix '~/.npm-global'
# Edit .profile
sudo echo "export PATH=~/.npm-global/bin:$PATH" > ~/.profile
# Back on the command line, update system variables
source ~/.profile
fi