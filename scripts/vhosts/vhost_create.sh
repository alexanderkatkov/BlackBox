#!/usr/bin/env bash
#
# Create new vhost
echo ">>> VHost creation"

# Variables
# vhost url from config.yml
URL=$1
# vhost subdirectory from config.yml
DIR=$2
# .conf file name
vhost_file="${URL}.conf"

# Creating VHosts
if ! test -f "/etc/apache2/sites-available/${vhost_file}"; then
sudo mkdir -p /var/www/${URL}/html/${DIR}

echo "==> Creating ${vhost_file}..."

sudo cat <<EOF > /etc/apache2/sites-available/${vhost_file}
<VirtualHost *:80>
    ServerName ${URL}
    ServerAlias www.${URL}
    RewriteEngine On

    DocumentRoot /var/www/${URL}/html/${DIR}

    <Directory /var/www/${URL}/html>
        AllowOverride All
        Order Allow,Deny
        Allow from All
    </Directory>

    <Directory /var/www/${URL}>
        Options FollowSymlinks
    </Directory>

    ErrorLog /var/log/apache2/${URL}_error.log
    CustomLog /var/log/apache2/${URL}_access.log combined
</VirtualHost>
EOF
else
echo "==> ${vhost_file} already exists..."
fi