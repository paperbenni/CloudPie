#!/bin/bash
pushd ~
rm -rf cloudpie
mkdir cloudpie

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
        sudo apt install -y git agrep wget p7zip-full unrar
        mkdir -p ~/retroarch/retroarch

        mkdir -p ~/cloudpie/path
        rm ~/cloudpie/path/retroarch
        pushd ~/cloudpie
        mkdir save
        cd path
        wget retroarch.surge.sh/retroarch
        chmod +x retroarch

        if ./retroarch --version; then
            echo "retroarch installed successfully"
        else
            echo "retroarch install failed"
            exit 1
        fi

        #generate new retroarch config files
        rm -rf ~/.config/retroarch
        timeout 8 ./retroarch

        popd

        curl https://raw.githubusercontent.com/paperbenni/CloudPie/master/cores.sh | bash

        wget https://github.com/ncw/rclone/releases/download/v1.46/rclone-v1.46-linux-amd64.deb
        sudo dpkg -i -y *.deb
        rm *.deb

        # install the fuzzy finder fzf
        pushd cloudpie/path
        wget https://github.com/junegunn/fzf-bin/releases/download/0.17.5/fzf-0.17.5-linux_amd64.tgz
        tar zxvf *.tgz
        rm *.tgz
        chmod +x ./fzf
        popd

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
mkdir -p .config/cloudpie

mkdir retrorecords

mkdir retroarch
pushd retroarch
mkdir quicksave

popd

#update retroarch

cd cloudpie
cget update.sh platforms.txt sync.sh download.sh login.sh start.sh
chmod +x update.sh sync.sh start.sh download.sh login.sh
cget bin/cloudrom bin/cloudpie
sudo mv cloudrom /bin/
sudo mv cloudpie /bin/
sudo chmod +x /bin/cloudrom /bin/cloudpie

bash update.sh

cd ~
mkdir -p .config/rclone
pushd .config/rclone
cget rclone.conf

# change the retroarch directory configuration
changeconf system_directory '~/retroarch/bios'
changeconf savefile_directory '~/cloudpie/save'
changeconf recording_output_directory '~/retrorecords'
changeconf cheat_database_path '~/retroarch/cheats'
changeconf libretro_directory '~/retroarch/cores'
changeconf joypad_autoconfig_dir '~/retroarch/autoconfig'
changeconf content_database_path = '~/retroarch/database'
changeconf menu_driver 'ozone'
changeconf assets_directory '~/retroarch/assets/'
changeconf libretro_info_path '~/retroarch/info/'


clear

~/cloudpie/login.sh
popd
