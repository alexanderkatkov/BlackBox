#!/usr/bin/env bash
#
# Base packages provision file
echo ">>> Base packages installation"

# git package provision
echo "==> Checking if Git package is installed..."
if type git &> /dev/null
then
echo "==> Git is already installed!"
else
echo "==> Installing Git..."
sudo apt-get -y install git
fi

# package providing add-apt-repository command provision
echo "==> Checking if Dialog package is installed..."
if type dialog &> /dev/null
then
echo "==> Dialog is already installed!"
else
echo "==> Installing Dialog..."
sudo apt-get -y install dialog
fi

# build-essential packages group provision
echo "==> Checking if Build Essential packages are installed..."
if type g++ &> /dev/null
then
echo "==> Build Essential are already installed!"
else
echo "==> Installing Build Essential..."
sudo apt-get -y install build-essential
fi

# zip & unzip packages provision
echo "==> Checking if Zip & Unzip packages are installed..."
if type zip &> /dev/null
then
echo "==> Zip & Unzip are already installed!"
else
echo "==> Installing Zip & Unzip..."
sudo apt-get -y install zip unzip
fi

# sendmail provision
echo "==> Checking if Sendmail package is installed..."
if type sendmail &> /dev/null
then
echo "==> Sendmail is already installed!"
else
echo "==> Installing Sendmail..."
sudo apt-get -y install sendmail
fi
