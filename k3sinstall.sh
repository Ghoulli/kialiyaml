#!/bin/bash
echo 'Script made by NQ'
if [ $(id -u) -ne 0 ]
	then echo "Please run the script as root (sudo)"
	exit
fi

if [ "$(dpkg -l | awk '/docker-ce/ {print }'|wc -l)" -ge 1 ]; then
	echo 'Opening necessary ports'
	ufw allow 6443/tcp
	ufw allow 443/tcp

	echo 'Install k3s binary'
	curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --node-name $(hostname)

	echo 'Check if k3s is installed correctly'
	systemctl status k3s
else
  echo 'Docker is not installed, please install docker using dockerinstall.sh or by hand'
fi
