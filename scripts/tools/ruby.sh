#!/usr/bin/env bash
#
# Ruby provision file
echo ">>> Ruby installation & configuration"

# Mailhog package provision
echo "==> Checking if Ruby is installed..."
if type mailhog &> /dev/null
then
echo "==> Ruby already installed!"
else
echo "==> Addding Ruby repository"
# Adding actual repository for 'PHP'
sudo apt-add-repository -y ppa:brightbox/ruby-ng
# Update repository list
sudo apt-get -y update

echo "==> Installing Ruby..."
# Install Ruby packages
sudo apt-get -y install ruby ruby-dev
fi