#!/bin/bash

apt-get -y update

# Install Node.Js

NODE_VER=5.5.0

wget http://nodejs.org/dist/v${NODE_VER}/node-v${NODE_VER}-linux-x64.tar.gz -O /tmp/node-v${NODE_VER}.tar.gz
tar -xvf /tmp/node-v${NODE_VER}.tar.gz -C /tmp
mv /tmp/node-v${NODE_VER}-linux-x64 /opt/nodejs-v${NODE_VER}

echo "ln -s /opt/nodejs-v${NODE_VER}/bin/node /usr/bin/node"
ln -s /opt/nodejs-v${NODE_VER}/bin/node /usr/bin/node
ln -s /opt/nodejs-v${NODE_VER}/bin/npm /usr/bin/npm
node-${NODE_VER} -v
rm /tmp/node-v${NODE_VER}.tar.gz

echo Installing Git wget
apt-get install -y git

echo Installing Docker
curl -fsSL https://get.docker.com | sh

echo installing ansible
apt-get install ansible

#installing robo mongo
wget https://download.robomongo.org/1.0.0-rc1/linux/robomongo-1.0.0-rc1-linux-x86_64-496f5c2.tar.gz
tar xf robomongo-1.0.0-rc1-linux-x86_64-496f5c2.tar.gz
#sudo mv robomongo /usr/bin/robomongo

#downloading rocket chat client
wget https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/2.6.0/rocketchat_2.6.0_amd64.deb

echo Installing Visual Studio Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sh -c 'echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

apt-get update
apt-get install -y code # or code-insiders


echo Installing zoom plugin
wget https://zoom.us/client/latest/zoom_amd64.deb

dpkg -i zoom_amd64.deb
apt-get install -f


