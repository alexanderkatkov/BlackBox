#!/usr/bin/env bash
#
# Updating repository list & upgrading packages
echo ">>> System & packages update."

# Update repository list
sudo apt-get -y update
# Upgrade packages with suspending GRUB configuration request
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" upgrade
# Removing unnecessary packages
sudo apt-get autoremove -y