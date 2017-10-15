#!/usr/bin/env bash
#
# Apache2 provision file
echo ">>> Apache2 installation & configuration"

# Apache2 package provision
echo "==> Checking if Apache2 is installed..."
if type apache2 &> /dev/null
then
echo "==> Apache2 already installed!"
else
echo "==> Addding Apache2 repository"
# Adding actual repository for 'Apache 2'
sudo add-apt-repository -y ppa:ondrej/apache2
# Update repository list
sudo apt-get -y update

echo "==> Installing Apache2..."
sudo apt-get -y install apache2

echo "==> [www] folder rights permanent fix..."
# Set common rights for [www] folder
sudo chown -R www-data:www-data /var/www
sudo chmod -R 775 /var/www
# Add user account to www-data group
sudo adduser $USER www-data

echo "==> Enabling Apache2 standard modules..."
#	Customization of HTTP request and response headers support
sudo a2enmod headers
# Provides a rule-based rewriting engine to rewrite requested URLs on the fly
sudo a2enmod rewrite
# Restart Apache2 to activate configuration
sudo service apache2 restart
fi
