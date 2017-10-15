#!/usr/bin/env bash
#
# Mailhog provision file
echo ">>> Mailhog installation & configuration"

# Mailhog package provision
echo "==> Checking if Mailhog is installed..."
if type mailhog &> /dev/null
then
echo "==> Mailhog already installed!"
else
echo "==> Download binary..."
# Download binary from GitHub
wget -O ~/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64
# Make it executable
chmod +x ~/mailhog

# Register mailhog as service & make it start on reboot
echo "==> Register mailhog as service..."
sudo tee /etc/init/mailhog.conf <<EOL
description "Mailhog"
start on runlevel [2345]
stop on runlevel [!2345]
respawn
pre-start script
    exec su - vagrant -c "/usr/bin/env ~/mailhog > /dev/null 2>&1 &"
end script
EOL
# Start it now in the background
sudo service mailhog start
fi