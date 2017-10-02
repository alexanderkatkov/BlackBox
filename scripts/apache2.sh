#!/usr/bin/env bash
#
# Apache2 provision file

echo $'\n'
echo "---------------------------------------------"
echo "Apache2 provision."
echo "---------------------------------------------"
echo $'\n'

# Checking if Apache2 is already installed
echo "Checking if Apache2 is installed..."
if type apache2 &> /dev/null
then
  echo "Apache2 already installed!"
else
  echo "Installing Apache2..."
  sudo apt-get install -y apache2

  # [www] folder rights permanent fix

  # Set common rights for [www] folder
  sudo chown -R www-data:www-data /var/www
  sudo chmod -R 775 /var/www
  # Add user account to www-data group
  sudo adduser $USER www-data

  #	Customization of HTTP request and response headers support
  sudo a2enmod headers
  # Restart Apache2 to activate configuration
  sudo service apache2 restart
fi
