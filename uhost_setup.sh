#!/bin/bash

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

