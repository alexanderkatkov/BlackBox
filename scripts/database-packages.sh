#!/usr/bin/env bash
#
# Database packages provision file

echo $'\n'
echo "---------------------------------------------"
echo "Database packages provision."
echo "---------------------------------------------"
echo $'\n'

# Checking if MySQL is already installed
echo "Checking if MySQL is installed..."
if type mysql &> /dev/null
then
	echo "MySQL is already installed!"
else
	echo "Installing MySQL..."
	# Adding actual repository for 'MySQL'
	sudo wget http://dev.mysql.com/get/mysql-apt-config_0.8.7-1_all.deb
	# Install MySQL releases package
	sudo DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.7-1_all.deb
	# Update repository list
	sudo apt-get update -y
	# Set root password for MySQL
	pass="root"
	sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $pass"
	sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $pass"
	sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password $pass"
	sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password $pass"
	# Installing MySQL client & server
	DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server mysql-client
	echo "Configuring MySQL..."
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

# Checking if SQLite3 is already installed
echo "Checking if SQLite3 is installed..."
if type sqlite3 &> /dev/null
then
	echo "SQLite is already installed!"
else
	echo "Installing SQLite..."
	sudo apt-get install -y sqlite3 libsqlite3-dev
fi
