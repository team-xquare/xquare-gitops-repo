#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <AWS_ACCESS_KEY_ID> <AWS_SECRET_ACCESS_KEY>"
    exit 1
fi

AWS_ACCESS_KEY_ID=$1
AWS_SECRET_ACCESS_KEY=$2
AWS_DEFAULT_REGION="ap-northeast-2"
AWS_DEFAULT_OUTPUT="json"

# gocd agent install
sudo install -m 0755 -d /etc/apt/keyrings
curl https://download.gocd.org/GOCD-GPG-KEY.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gocd.gpg
sudo chmod a+r /etc/apt/keyrings/gocd.gpg
echo "deb [signed-by=/etc/apt/keyrings/gocd.gpg] https://download.gocd.org /" | sudo tee /etc/apt/sources.list.d/gocd.list
sudo apt-get update
sudo apt-get install go-agent -y

# gocd server < - > gocd agent(this node) connect
echo "wrapper.app.parameter.100=-serverUrl" | sudo tee -a /usr/share/go-agent/wrapper-config/wrapper-properties.conf
echo "wrapper.app.parameter.101=https://gocd.xquare.app/go" | sudo tee -a /usr/share/go-agent/wrapper-config/wrapper-properties.conf
sudo systemctl restart go-agent

# go 유저로 전환
sudo su go

# Docker Engine install
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

sudo apt-get install docker-ce docker-ce-cli -y

sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker

sudo usermod -aG docker go
# 다른 그룹의 사용자도 접근할 수 있도록 권한을 변경
sudo chmod 666 /var/run/docker.sock

# aws-cli install
sudo apt-get update
sudo apt-get install awscli -y

mkdir -p ~/.aws

cat <<EOL > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOL

cat <<EOL > ~/.aws/config
[default]
region = $AWS_DEFAULT_REGION
output = $AWS_DEFAULT_OUTPUT
EOL





