#!/usr/bin/env bash
#
# Development tools provision file

echo $'\n'
echo "---------------------------------------------"
echo "Development tools provision."
echo "---------------------------------------------"
echo $'\n'

# Install 'zip' & 'unzip' packages
if [ command -v zip >/dev/null 2>&1 ]; then
	echo "Zip & Unzip is already installed!"
else
	echo "Installing Zip & Unzip..."

	sudo apt -y install zip unzip
fi

# Install 'Composer' package
if [ command -v composer >/dev/null 2>&1 ]; then
	echo "Composer is already installed!"
else
	echo "Installing Composer..."

	# Download and install 'Composer' as a system-wide command named 'composer'
	curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
	# Adding composer to PATH
	export PATH="~/.composer/vendor/bin:$PATH"
	# Make .composer/ folder * make it writable to Vagrant user
	sudo mkdir -p /home/vagrant/.composer/
	sudo chown -R vagrant:vagrant /home/vagrant/.composer/
fi

# Install 'Ruby' package
if [ command -v ruby >/dev/null 2>&1 ]; then
	echo "Ruby is already installed!"
else
	echo "Installing Ruby..."

	# Adding actual repository for 'Ruby'
	sudo apt-add-repository -y ppa:brightbox/ruby-ng
	# Update repository list
	sudo apt-get update -y
	# Install 'Ruby'
	sudo apt install -y ruby
	# Install 'Ruby Dev'. Needed for building Ruby packages
	sudo apt install -y ruby-dev
fi

# Install 'Mailhog' package
if [ command mailhog status service >/dev/null 2>&1 ]; then
	echo "Mailhog is already installed!"
else
	echo "Installing Mailhog..."

	# Download binary from github
	sudo wget --quiet -O /usr/local/bin/mailhog https://github.com/mailhog/MailHog/releases/download/v0.2.1/MailHog_linux_amd64
	# Make it executable
	sudo chmod +x /usr/local/bin/mailhog
	# Make it start on reboot
	sudo tee /etc/systemd/system/mailhog.service <<EOL
	[Unit]
	Description=Mailhog
	After=network.target
	[Service]
	User=vagrant
	ExecStart=/usr/bin/env /usr/local/bin/mailhog > /dev/null 2>&1 &
	[Install]
	WantedBy=multi-user.target
EOL
	# Reload systemd files before enabling mailhog
	sudo systemctl daemon-reload
	# Start on reboot
	sudo systemctl enable mailhog
	# Start background service now
	sudo systemctl start mailhog
fi

# Install 'Git' package
if [ command --version git >/dev/null 2>&1 ]; then
	echo "Git is already installed!"
else
	echo "Installing Git..."

	sudo apt install -y git
fi

# Install 'WP CLI' package
if [ command --version wp >/dev/null 2>&1 ]; then
	echo "WP CLI is already installed!"
else
	echo "Installing WP CLI..."

	# Download installation phar
	sudo curl -sL -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	# Make the file executable
	sudo chmod +x wp-cli.phar
	# Move to WP CLI path folder
	sudo mv wp-cli.phar /usr/local/bin/wp
fi

# Install 'WP CLI' package
if [ command --version node >/dev/null 2>&1 ]; then
	echo "Node.js is already installed!"
else
	echo "Installing Node.js..."

	# Download installation
	curl --quiet -O -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
	# Installing Node.js package
	sudo apt-get install -y nodejs
	sudo ln -s /usr/bin/nodejs /usr/bin/node
	# Installing NPM package manager
	sudo apt install -y npm
	npm install npm@latest -g

	# Installing base Node.js packages
	# Gulp
	npm i -g gulp
	# Bower
	npm i -g bower
fi
