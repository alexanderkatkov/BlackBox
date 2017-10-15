#!/usr/bin/env bash
#
# Create new vhost
echo ">>> VHost enabling"

# Variables
# vhost url from config.yml
URL=$1
# .conf file name
vhost_file="${URL}.conf"

# Enabling VHosts
if ! test -f "/etc/apache2/sites-available/${vhost_file}"; then
echo "==> Site not exist..."
else
echo "==> Enabling ${URL}..."
# Enable .conf file
sudo a2ensite ${vhost_file}
# Reload Apache2 to activate configuration
sudo service apache2 restart
fi