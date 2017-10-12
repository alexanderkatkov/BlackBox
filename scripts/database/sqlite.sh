#!/usr/bin/env bash
#
# SQLite3 provision file
echo ">>> SQLite3 installation & configuration"

# SQLite3 package provision
echo "==> Checking if SQLite3 is installed..."
if type sqlite3 &> /dev/null
then
echo "SQLite3 is already installed!"
else
echo "==> Addding SQLite3 repository..."
# Adding actual repository for 'PHP'
sudo add-apt-repository ppa:jonathonf/backports
# Update repository list
sudo apt-get -y update

echo "==> Installing SQLite3..."
# Install SQLite3 packages
sudo apt-get -y install sqlite3 libsqlite3-dev
fi