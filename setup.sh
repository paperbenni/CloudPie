#!/bin/bash

echo "installing cloudpie"

DEVICE=$(uname -m)

function changeconf() {
    if [ -z "$2" ]; then
        echo "usage: changeconf option value"
    fi
    if [ -z "$3" ]; then
        if ! [ -e ~/.config/retroarch/retroarch.cfg ]; then
            echo "generating config"
            timeout 5 retroarch
        fi
        pushd ~/.config/retroarch
        NEWVALUE="$1 = \"$2\""
        sed -i "/$1/c $NEWVALUE" retroarch.cfg
        popd
    fi

}

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
        sudo apt install -y git agrep wget p7zip-full
        mkdir -p ~/retroarch/retroarch

        pushd ~retroarch/retroarch
        wget retroarch.surge.sh/retroarch.zip
        unzip retroarch.zip
        rm retroarch.zip
        chmod +x retroarch
        if ./retroarch --version; then
            echo "retroarch installed successfully"
        else
            echo "retroarch install failed"
            exit 1
        fi
        popd

        curl https://raw.githubusercontent.com/paperbenni/CloudPie/master/cores.sh | bash

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

mkdir retrorecords

mkdir retroarch
pushd retroarch
mkdir saves
mkdir quicksaves

cget cores.sh
bash cores.sh
popd

mkdir -p .config/cloudpie
mkdir cloudpie
cd cloudpie
cget platforms.txt sync.sh download.sh

cd /bin
sudo cget cloudrom cloudpie
sudo chmod +x cloudrom cloudpie

cd ~
mkdir -p .config/rclone
pushd .config/rclone
cget rclone.conf

cd ~

# change the retroarch directory configuration
changeconf system_directory '~/retroarch/bios'
changeconf savefile_directory '~/cloudpie/save'
changeconf recording_output_directory '~/retrorecords'
changeconf cheat_database_path '~/retroarch/cheats'
changeconf libretro_directory '~/retroarch/cores'
changeconf joypad_autoconfig_dir '~/retroarch/autoconfig'
changeconf content_database_path = '~/retroarch/database/rdb'

clear
cd ~/cloudpie
echo "what's your username?"
read USERNAME
echo "enter password"
read PASSWORD

echo "$USERNAME" >username.txt
if rclone lsd mega:"$USERNAME" &>/dev/null; then
    echo "user exists, checking password"
    MEGAPASSWORD=$(rclone cat mega:"$USERNAME"/password.txt)
    if [ "$MEGAPASSWORD" = "$PASSWORD" ]; then
        echo "login sucessfull"
        sleep 2
    else
        echo "type in the correct password or choose another username please"
    fi
else
    echo "user not found, creating new account"
    echo "$PASSWORD" >~/cloudpie/password.txt
    rclone mkdir mega:"$USERNAME"
    rclone cp ~/cloudpie/password.txt mega:"$USERNAME/password.txt"
fi
