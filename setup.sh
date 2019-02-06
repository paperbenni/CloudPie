#!/bin/bash

echo "installing cloudpie"
DEVICE=$(uname -m)

case "$DEVICE" in
armv6l)
    echo "raspberry pi"
    ;;
x86_64)
    echo "PC"
    echo '~/cloudpie/roms' >~/.config/cloudpie/rom.conf
    sudo apt-get update
    sudo apt install -y retroarch libretro-*
    ;;
esac

sudo apt-get update
sudo apt install -y dialog wget curl agrep
pushd ~/
mkdir -p .config/cloudpie
mkdir cloudpie
cd cloudpie
wget https://raw.githubusercontent.com/paperbenni/CloudPie/master/platforms.txt
cd /bin
sudo wget https://raw.githubusercontent.com/paperbenni/CloudPie/master/bin/cloudrom
sudo chmod +x cloudrom
