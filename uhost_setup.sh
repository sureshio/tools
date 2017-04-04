#!/bin/bash

mkdir install_tmp
cd install_tmp

sudo apt-get -y update

# Install Node.Js

NODE_VER=5.5.0

wget http://nodejs.org/dist/v${NODE_VER}/node-v${NODE_VER}-linux-x64.tar.gz -O /tmp/node-v${NODE_VER}.tar.gz
tar -xvf /tmp/node-v${NODE_VER}.tar.gz -C /tmp
sudo mv /tmp/node-v${NODE_VER}-linux-x64 /opt/nodejs-v${NODE_VER}

echo "ln -s /opt/nodejs-v${NODE_VER}/bin/node /usr/bin/node"
sudo ln -s /opt/nodejs-v${NODE_VER}/bin/node /usr/bin/node
sudo ln -s /opt/nodejs-v${NODE_VER}/bin/npm /usr/bin/npm
node-${NODE_VER} -v
rm /tmp/node-v${NODE_VER}.tar.gz

echo Installing Git wget
sudo apt-get install -y git wget ansible


#installing robo mongo
wget https://download.robomongo.org/1.0.0-rc1/linux/robomongo-1.0.0-rc1-linux-x86_64-496f5c2.tar.gz
tar xf robomongo-1.0.0-rc1-linux-x86_64-496f5c2.tar.gz
sudo mv robomongo-1.0.0-rc1-linux-x86_64-496f5c2 /usr/bin/robomongo


echo Installing Visual Studio Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update
sudo apt-get install -y code # or code-insiders


#downloading rocket chat client
echo installing rocket chat
wget https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/2.6.0/rocketchat_2.6.0_amd64.deb
sudo dpkg -i rocketchat_2.6.0_amd64.deb
sudo apt-get install -f

echo Installing zoom plugin
wget https://zoom.us/client/latest/zoom_amd64.deb

sudo dpkg -i zoom_amd64.deb
sudo apt-get install -f

echo Installing Docker
curl -fsSL https://get.docker.com | sh

#cd .. && rm -rf install_tmp


sudo curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
