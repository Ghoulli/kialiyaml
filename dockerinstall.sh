#!/bin/bash

echo 'Script made by NQ'

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run the script as root (sudo)"
    exit 1
fi

echo 'Docker install script'
echo 'Updating & Upgrading'
apt update && apt upgrade -y

echo 'Installing necessities'
apt install -y curl unzip python3-pip python3-docker python3-flask

echo 'Installing Docker'
curl -fsSL https://get.docker.io/ | sh

echo 'Testing if the install completed correctly'
systemctl status docker

exit 0

