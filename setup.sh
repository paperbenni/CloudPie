#!/bin/bash

echo "installing cloudpie"
sudo apt-get update
sudo apt install -y dialog wget curl agrep
pushd ~/
mkdir cloudpie
cd cloudpie
wget https://raw.githubusercontent.com/paperbenni/CloudPie/master/platforms.txt
cd /bin
sudo wget https://raw.githubusercontent.com/paperbenni/CloudPie/master/bin/cloudrom
sudo chmod +x cloudrom
