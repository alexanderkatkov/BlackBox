#!/usr/bin/env bash
#
# PHP provision file
echo ">>> PHP installation & configuration"

# PHP package provision
echo "==> Checking if PHP is installed..."
if type php &> /dev/null
then
echo "==> PHP already installed!"
else
echo "==> Addding PHP repository"
# Adding actual repository for 'PHP'
sudo add-apt-repository -y ppa:ondrej/php
# Update repository list
sudo apt-get -y update

echo "==> Installing PHP..."
# Install PHP packages
sudo apt-get -y install php-fpm php-cli \
php-mysql php-pgsql php-sqlite3 php-gd php-apcu \
php-mcrypt php-gmp php-curl \
php-imap php-memcached \
php-imagick php-intl php-xdebug \
php-json php-mbstring \
php-zip php-xml php-mysql php-pear \
libapache2-mod-fastcgi

echo "==> Switching to FPM/FastCGI..."
# Enable PHP FPM in Apache2
sudo a2enmod proxy proxy_fcgi setenvif
sudo a2enconf php7.1-fpm

# Reload Apache2 & PHP-FPM to activate configuration
sudo service php7.1-fpm restart
sudo service apache2 restart

# Switching to @root user
sudo su

# Writing xDebug configuration
echo "==> Writing xDebug configuration..."
# Saving path to php.ini for later use
php_config="/etc/php/7.1/fpm/php.ini"
# Writing xDebug config to the end of php.ini file
sudo echo "; xdebug-remote
xdebug.remote_enable=On
xdebug.remote_autostart=On
xdebug.remote_connect_back=On
xdebug.remote_host=10.0.2.2
xdebug.idekey=XDEBUG" >> "$php_config"

# Configure PHP error reporting
echo "==> Changing PHP Error Reporting parameters..."
# Disable PHP short tags <?
sed -i 's/short_open_tag = On/short_open_tag = Off/g' $php_config
# Switching display PHP errors On
sed -i 's/display_errors = Off/display_errors = On/g' $php_config
# Setting error reporting level to recommended for the development
sed -i 's/error_reporting = .*/error_reporting = E_ALL | E_STRICT/g' $php_config
# Enable HTML markup for PHP error reporting
sed -i 's/html_errors = Off/html_errors = On/g' $php_config

# Switching back to @vagrant user
su vagrant

# Reload Apache2 & PHP-FPM to activate configuration
sudo service apache2 restart
sudo service php7.1-fpm restart
fi