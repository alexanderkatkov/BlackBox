#!/usr/bin/env bash
#
# Development tools provision file

echo $'\n'
echo "---------------------------------------------"
echo "Development tools provision."
echo "---------------------------------------------"
echo $'\n'

# Checking if SQLite3 is already installed
echo "Checking if ZIP package is installed..."
if type zip &> /dev/null
then
	echo "Zip & Unzip is already installed!"
else
	echo "Installing Zip & Unzip..."
	sudo apt -y install zip unzip
fi

# Checking if Composer is already installed
echo "Checking if Composer is installed..."
if type composer &> /dev/null
then
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

# Checking if Ruby is already installed
echo "Checking if Ruby is installed..."
if type ruby &> /dev/null
then
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

# Checking if Mailhog is already installed
echo "Checking if Mailhog is installed..."
if type mailhog &> /dev/null
then
	echo "Mailhog is already installed!"
else
	echo "Installing Mailhog"

	# Download binary from github
	wget --quiet -O ~/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64

	# Make it executable
	chmod +x ~/mailhog

	# Make it start on reboot
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

# Checking if Git is already installed
echo "Checking if Git is installed..."
if type git &> /dev/null
then
	echo "Git is already installed!"
else
	echo "Installing Git..."
	sudo apt install -y git
fi

# Checking if WP CLI is already installed
echo "Checking if WP CLI is installed..."
if type wp &> /dev/null
then
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

# Checking if Node.js is already installed
echo "Checking if Node.js is installed..."
if type node &> /dev/null
then
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
