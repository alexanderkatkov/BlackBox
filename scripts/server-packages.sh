#!/usr/bin/env bash
#
# Server packages provision file

echo $'\n'
echo "---------------------------------------------"
echo "Server packages provision."
echo "---------------------------------------------"
echo $'\n'

ip=$1

# Install service for email sending
sudo apt-get install -y sendmail

# Checking if Redis-server is already installed
echo "Checking if Redis-server is installed..."
if type redis-server &> /dev/null
then
	echo "Redis-server already installed!"
else
	echo "Installing Redis-server..."
	# Adding actual repository for 'Redis-server'
	sudo add-apt-repository -y ppa:chris-lea/redis-server
	# Update repository list
	sudo apt-get update -y
	# Install 'Redis-server'
	sudo apt-get install -y redis-server
fi

# Checking if PHP 7.1 is already installed
echo "Checking if PHP 7.1 is installed..."
if type php &> /dev/null
then
	echo "PHP 7.1 already installed!"
else
	echo "Installing PHP 7.1..."
	# Adding actual repository for 'PHP'
	sudo add-apt-repository -y ppa:ondrej/php
	# Update repository list
	sudo apt-get update -y
	# Install PHP packages
	sudo apt-get install -y php-cli \
	php-mysql php-pgsql php-sqlite3 php-gd php-apcu \
	php-mcrypt php-gmp php-curl \
	php-imap php-memcached \
	php-imagick php-intl php-xdebug \
	php-json php-mbstring \
	php-zip php-xml php-mysql php-pear
	# Install HTML-embedded scripting language
	sudo apt-get install -y libapache2-mod-php
	# Restart Apache2 to activate configuration
	sudo service apache2 restart
	echo $'Configuring xDebug & PHP error reporting.\n'
	# Switching to @root user
	sudo su
	# Writing xDebug configuration
	php_config="/etc/php/7.1/apache2/php.ini"
	sudo echo "; xdebug-remote
	xdebug.remote_enable = 1
	xdebug.remote_autostart = 1
	xdebug.remote_connect_back = 0
	xdebug.remote_host = 10.0.2.2
	xdebug.idekey=XDEBUG" >> "$php_config"
	# Configure PHP error reporting
	sudo sed -e '/^[^;]*display_errors/s/=.*$/= \On/' -i.bak /etc/php/7.1/apache2/php.ini
	sudo sed -e '/^[^;]*display_startup_errors/s/=.*$/= \On/' -i.bak /etc/php/7.1/apache2/php.ini
	sudo sed -e '/^[^;]*error_reporting/s/=.*$/= E\_ALL/' -i.bak /etc/php/7.1/apache2/php.ini
	# Restart Apache2 to activate configuration
	sudo service apache2 restart
fi

# Switching back to @vagrant user
su vagrant
