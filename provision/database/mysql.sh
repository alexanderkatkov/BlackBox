#!/usr/bin/env bash
#
# PHP provision file
echo ">>> MySQL installation & configuration"

# Getting @root password from config
root_pw=$1

# MySQL package provision
echo "==> Checking if MySQL is installed..."
if type mysql &> /dev/null
then
echo "==> MySQL already installed!"
else
echo "==> Addding MySQL repository..."
# Adding actual repository for 'MySQL'
# sudo wget http://dev.mysql.com/get/mysql-apt-config_0.8.8-1_all.deb
# Install MySQL releases update
# sudo DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.8-1_all.deb
# Update repository list
sudo apt-get -y update

echo "==> Setting MySQL @root password..."
# Setting password
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $root_pw"
sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password $root_pw"
# Password confirmation
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $root_pw"
sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password $root_pw"

echo "==> Installing MySQL..."
# Install MySQL server & client
sudo DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server mysql-client

echo "==> MySQL post-install configuration..."
# Configure MySQL default charset to real utf8
sudo sed -i '/\[client\]/a default-character-set = utf8mb4' /etc/mysql/my.cnf
sudo sed -i '/\[mysqld\]/a character-set-client-handshake = FALSE' /etc/mysql/my.cnf
sudo sed -i '/\[mysqld\]/a character-set-server = utf8mb4' /etc/mysql/my.cnf
sudo sed -i '/\[mysqld\]/a collation-server = utf8mb4_unicode_ci' /etc/mysql/my.cnf
# Allow remote connections to MySQL Server
sudo sed -i "s/[# ]*bind-address\([[:space:]]*\)=\([[:space:]]*\).*/bind-address = 0.0.0.0/g" /etc/mysql/my.cnf

# Retart MySQL Server to apply new configuration
sudo service mysql reload
fi