#!/usr/bin/env bash
#
# Apache2 provision file
URL=$1
DIR=$2

echo $'\n' 
echo "---------------------------------------------"
echo "Creating virtual host for ${URL}"
echo "---------------------------------------------"
echo "Creating directory for ${URL}..."

vhost_file="${URL}.conf"

if [ ! -f $vhost_file ]; then

    sudo mkdir -p /var/www/${URL}/html/${DIR}

    echo "Creating ${vhost_file}..."

    cat <<EOF > /etc/apache2/sites-available/${vhost_file}
    <VirtualHost *:80>
        ServerName ${URL}
        ServerAlias www.${URL}
        
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

    echo "Enabling ${URL}. Will probably tell you to restart Apache..."
    sudo a2ensite ${vhost_file}

    echo "Restarting Apache2..."
    sudo service apache2 restart

fi
