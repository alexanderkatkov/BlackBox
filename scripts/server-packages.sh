#!/usr/bin/env bash
#
# Server packages provision file

echo $'\n'
echo "---------------------------------------------"
echo "Server packages provision."
echo "---------------------------------------------"
echo $'\n'

ip=$1

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
	sudo apt update -y
	# Install 'Redis-server'
	sudo apt install -y redis-server
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
	sudo apt update -y
	# Install PHP-FPM
	sudo apt install -y php-fpm
	echo $'Server configuration to use FPM.\n'
	# Enable PHP 1 FPM in Apache2
	sudo a2enmod proxy proxy_fcgi setenvif
	sudo a2enconf php-fpm
	# Enable Apache 2 mod_rewrite module
	sudo a2enmod rewrite
	# Reload Apache2 & PHP-FPM to activate configuration
	sudo service php-fpm restart
	sudo service apache2 restart
	# Install PHP packages
	sudo apt install -y php-cli \
	php-mysql php-pgsql php-sqlite3 php-gd php-apcu \
	php-mcrypt php-gmp php-curl \
	php-imap php-memcached \
	php-imagick php-intl php-xdebug \
	php-json php-mbstring \
	php-zip php-xml php-mysql php-pear
	# Reload Apache2 & PHP-FPM to activate configuration
	sudo service php-fpm restart
	sudo service apache2 restart
	echo $'Configuring xDebug & PHP error reporting.\n'
	# Switching to @root user
	sudo su
	# Writing xDebug configuration
	xdebug_config="/etc/php/7.1/mods-available/xdebug.ini"
	sudo echo "; xdebug-remote
	xdebug.remote_enable=1
	xdebug.remote_connect_back=1
	xdebug.idekey=XDEBUG
	xdebug.remote_autostart=1
	xdebug.remote_handler=dbgp
	xdebug.remote_port=9000
	xdebug.remote_host=${ip}" >> "$xdebug_config"
	# Configure PHP error reporting
	sudo sed -e '/^[^;]*display_errors/s/=.*$/= \On/' -i.bak /etc/php/7.1/fpm/php.ini
	sudo sed -e '/^[^;]*display_startup_errors/s/=.*$/= \On/' -i.bak /etc/php/7.1/fpm/php.ini
	sudo sed -e '/^[^;]*error_reporting/s/=.*$/= E\_ALL/' -i.bak /etc/php/7.1/fpm/php.ini
	# Reload Apache2 & PHP-FPM to activate configuration
	sudo service php-fpm restart
	sudo service apache2 restart
fi

# Switching back to @vagrant user
su vagrant
