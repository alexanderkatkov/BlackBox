#!/usr/bin/env bash
#
# Database packages provision file

echo $'\n'
echo "---------------------------------------------"
echo "Database packages provision."
echo "---------------------------------------------"
echo $'\n'

if [ command --version mysql >/dev/null 2>&1 ]; then
	echo "MySQL is already installed!"
else
	echo "Installing MySQL..."

	# Adding actual repository for 'MySQL'
	sudo add-apt-repository -y ppa:ondrej/mysql-5.7
	# Update repository list
	sudo apt update -y

	# Set root password for MySQL
	debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
	debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

	sudo apt install -y mysql-server mysql-client

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


if [ command --version sqlite3 >/dev/null 2>&1 ]; then
	echo "SQLite is already installed!"
else
	echo "Installing SQLite..."

	sudo apt-get install -y sqlite3 libsqlite3-dev
fi
