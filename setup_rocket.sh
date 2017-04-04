#!/bin/bash

#downloading rocket chat client
echo installing rocket chat
wget https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/2.6.0/rocketchat_2.6.0_amd64.deb
sudo dpkg -i rocketchat_2.6.0_amd64.deb
sudo apt-get install code
