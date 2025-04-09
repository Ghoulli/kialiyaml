#!/bin/bash

echo 'Script made by NQ'

if [ "$(id -u)" -ne 0 ]; then 
    echo "Please run the script as root (sudo)"
    exit 1
fi

echo 'Are you running the script on your K3S-control machine?'
echo '[y/n], please fill in only the letter.'
read k3scheck
k3scheck=$(echo "$k3scheck" | tr -d '\r\n' | xargs)

# Optional: Debug to verify what was read
# echo "DEBUG: k3scheck='$k3scheck'"

if [ "$k3scheck" = "n" ]; then
    echo 'Please run the script on your K3S-control machine instead'
    exit 1
fi

if [ "$(dpkg -l | awk '/docker-ce/ {print }' | wc -l)" -ge 1 ]; then
    echo 'Opening necessary ports'
    ufw allow 6443/tcp
    ufw allow 443/tcp
    ufw allow 8080/tcp
    ufw allow 80/tcp

    echo 'Install k3s binary'
    curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --node-name "$(hostname)"

    echo 'Doing some pre-config'
    mkdir -p ~/.kube
    cp /etc/rancher/k3s/k3s.yaml ~/.kube/config

    echo 'Check if k3s is installed correctly'
    systemctl status k3s
else
    echo 'Docker is not installed, please install docker using dockerinstall.sh or by hand'
fi

exit 0

