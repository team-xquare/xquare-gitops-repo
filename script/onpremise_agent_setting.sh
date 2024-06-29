#!/bin/bash

sudo adduser --disabled-password --gecos "" go

echo "go ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/go

sudo -i -u go << 'EOF'
sudo install -m 0755 -d /etc/apt/keyrings
curl https://download.gocd.org/GOCD-GPG-KEY.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gocd.gpg
sudo chmod a+r /etc/apt/keyrings/gocd.gpg
echo "deb [signed-by=/etc/apt/keyrings/gocd.gpg] https://download.gocd.org /" | sudo tee /etc/apt/sources.list.d/gocd.list
sudo apt-get update
sudo apt-get install -y go-agent

echo "wrapper.app.parameter.100=-serverUrl" | sudo tee -a /usr/share/go-agent/wrapper-config/wrapper-properties.conf
echo "wrapper.app.parameter.101=https://gocd.xquare.app/go" | sudo tee -a /usr/share/go-agent/wrapper-config/wrapper-properties.conf
sudo systemctl restart go-agent

sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce
sudo usermod -aG docker $USER
newgrp docker
EOF
