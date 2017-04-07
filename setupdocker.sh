#!/bin/bash

echo "Starting setup `date` " 

echo "Installing Docker" 
curl -fsSL https://get.docker.com | sudo sh

echo "Installing Docker Compose" 
sudo curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker --version
docker-compose --version
