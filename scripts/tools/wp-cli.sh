#!/usr/bin/env bash
#
# WP-CLI provision file
echo ">>> WP-CLI installation & configuration"

# Mailhog package provision
echo "==> Checking if WP-CLI is installed..."
if type wp &> /dev/null
then
echo "==> WP-CLI already installed!"
else
echo "==> Download installer & performing install..."
# Download installer & performing install
sudo curl -O -sL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# Make the file executable
sudo chmod +x wp-cli.phar
# Move to WP-CLI path folder
sudo mv wp-cli.phar /usr/local/bin/wp
fi