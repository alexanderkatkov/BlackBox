#!/usr/bin/env bash
#
# Server packages provision file

echo $'\n'
echo "---------------------------------------------"
echo "Server packages provision."
echo "---------------------------------------------"
echo $'\n'

ip=$1

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

if type php &> /dev/null
then
	echo "PHP 7.0 already installed!"
else
	echo "Installing PHP 7.0..."


	# Adding actual repository for 'PHP'
	sudo add-apt-repository -y ppa:ondrej/php
	# Update repository list
	sudo apt update -y

	# Install PHP-FPM
	sudo apt install -y php7.0-fpm

	echo $'Server configuration to use FPM.\n'
	# Enable PHP 7.0 FPM in Apache2
	sudo a2enmod proxy proxy_fcgi setenvif
	sudo a2enconf php7.0-fpm

	# Reload Apache2 & PHP-FPM to activate configuration
	sudo service php7.0-fpm restart
	sudo service apache2 restart

	# Install PHP packages
	sudo apt install -y php7.0-cli \
	php7.0-mysql php7.0-pgsql php7.0-sqlite3 php7.0-gd php7.0-apcu \
	php7.0-mcrypt php7.0-gmp php7.0-curl \
	php7.0-imap php7.0-memcached \
	php7.0-imagick php7.0-intl php7.0-xdebug \
	php7.0-json php7.0-opcache php7.0-mbstring \
	php7.0-zip php7.0-xml php7.0-mysql php-pear

	# Reload Apache2 & PHP-FPM to activate configuration
	sudo service php7.0-fpm restart
	sudo service apache2 restart

	echo $'Configuring xDebug & PHP error reporting.\n'
	# Switching to @root user
	sudo su
	# Writin xDebug configuration
	xdebug_config="/etc/php/7.0/mods-available/xdebug.ini"
	sudo echo "; xdebug-remote
	xdebug.remote_enable=1
	xdebug.remote_connect_back=1
	xdebug.idekey=XDEBUG
	xdebug.remote_handler=dbgp
	xdebug.remote_port=9000
	xdebug.remote_autostart=1
	xdebug.remote_host=${ip}" >> "$xdebug_config"

	# Configure PHP error reporting
	sudo sed -e '/^[^;]*display_errors/s/=.*$/= \On/' -i.bak /etc/php/7.0/fpm/php.ini
	sudo sed -e '/^[^;]*display_startup_errors/s/=.*$/= \On/' -i.bak /etc/php/7.0/fpm/php.ini
	sudo sed -e '/^[^;]*error_reporting/s/=.*$/= E\_ALL/' -i.bak /etc/php/7.0/fpm/php.ini

	# Reload Apache2 & PHP-FPM to activate configuration
	sudo service php7.0-fpm restart
	sudo service apache2 restart
fi

su vagrant
