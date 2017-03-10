#!/usr/bin/env bash

if [ dpkg -l apache2 &> /dev/null ]
then
    echo "Apache2 installed"
else
    sudo atp-get install -y apache2
fi

echo "$1 - $2"