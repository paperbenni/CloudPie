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

    if apt --version; then
        sudo apt-get update
        sudo apt install -y retroarch git agrep wget rclone libretro-* p7zip-full
    fi

    if pacman --version; then
        curl https://raw.githubusercontent.com/paperbenni/CloudPie/master/packages/arch.txt | sudo pacman -S -
    fi

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
