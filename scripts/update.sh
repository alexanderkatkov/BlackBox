#!/usr/bin/env bash
#
# System silent update file
echo " >>> System & packages update."

# Updating & upgrading packages
# Update repository list
sudo apt-get update -y
# Upgrade packages with suspending GRUB configuration request
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" upgrade
# Removing unnecessary packages
sudo apt-get autoremove -y