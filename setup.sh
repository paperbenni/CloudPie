#!/bin/bash

echo "installing cloudpie"

DEVICE=$(uname -m)

case "$DEVICE" in
armv6l)
    echo "raspberry pi"
    sudo apt update
    sudo apt install wget agrep p7zip-full git wget curl
    wget https://downloads.rclone.org/v1.46/rclone-v1.46-linux-arm64.deb
    mv *.deb rclone.deb
    sudo dpkg -i rclone.deb
    rm rclone.deb
    ;;
x86_64)
    echo "PC"
    echo '~/cloudpie/roms' >~/.config/cloudpie/rom.conf

    if apt --version; then
        sudo apt-get update
        sudo apt install -y retroarch git agrep wget libretro-* p7zip-full
        wget https://github.com/ncw/rclone/releases/download/v1.46/rclone-v1.46-linux-amd64.deb
        mv *.deb rclone.deb
        sudo dpkg -i -y rclone.deb
        rm rclone.deb
    fi

    if pacman --version; then
        curl https://raw.githubusercontent.com/paperbenni/CloudPie/master/packages/arch.txt | sudo pacman -S -
    fi
    ;;
esac

function cget() {
    if [ -z "$1" ]; then
        echo "usage: cget filename"
    else
        for file in "$@"; do
            wget https://raw.githubusercontent.com/paperbenni/CloudPie/master/"$file"
        done
    fi
}

pushd ~/

mkdir retroarch
pushd retroarch
mkdir saves
mkdir quicksaves
popd

mkdir -p .config/cloudpie
mkdir cloudpie
cd cloudpie
cget platforms.txt sync.sh download.sh

cd /bin
sudo cget cloudrom cloudpie
sudo chmod +x cloudrom cloudpie

mkdir -p .config/rclone
pushd .config/rclone
cget rclone.conf
popd

clear
cd ~/cloudpie
echo "what's your username?"
read USERNAME
echo "$USERNAME" > username.txt
if rclone lsd mega:"$USERNAME" &>/dev/null; then
    echo "user found, type in password"
else
    echo "user not found, creating account"
fi
