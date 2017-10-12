#!/usr/bin/env bash
#
# Composer provision file
echo ">>> Composer installation & configuration"

# Mailhog package provision
echo "==> Checking if Composer is installed..."
if type mailhog &> /dev/null
then
echo "==> Composer already installed!"
else
echo "==> Download installer & performing install..."
# Download installer & performing install
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

echo "==> Configuring folder rights..."
# Make .composer/ folder * make it writable to Vagrant user
sudo mkdir -p /home/vagrant/.composer/
sudo chown -R vagrant:vagrant /home/vagrant/.composer/
fi