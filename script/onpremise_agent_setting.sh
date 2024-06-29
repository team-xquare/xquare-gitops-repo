#!/bin/bash

# Docker Engine 설치
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli

sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker

sudo usermod -aG docker go
# 다른 그룹의 사용자도 접근할 수 있도록 권한을 변경
sudo chmod 666 /var/run/docker.sock

# aws-cli 설치
sudo apt-get update
sudo apt-get install awscli

# gocd agent 설치
sudo install -m 0755 -d /etc/apt/keyrings
curl https://download.gocd.org/GOCD-GPG-KEY.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gocd.gpg
sudo chmod a+r /etc/apt/keyrings/gocd.gpg
echo "deb [signed-by=/etc/apt/keyrings/gocd.gpg] https://download.gocd.org /" | sudo tee /etc/apt/sources.list.d/gocd.list
sudo apt-get update
sudo apt-get install go-agent

echo "wrapper.app.parameter.100=-serverUrl" | sudo tee -a /usr/share/go-agent/wrapper-config/wrapper-properties.conf
echo "wrapper.app.parameter.101=https://gocd.xquare.app/go" | sudo tee -a /usr/share/go-agent/wrapper-config/wrapper-properties.conf
sudo systemctl restart go-agent



