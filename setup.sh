#!/bin/bash
pushd ~
rm -rf cloudpie
mkdir cloudpie

curl https://raw.githubusercontent.com/paperbenni/CloudPie/master/functions.sh >cloudpie/functions.sh
source cloudpie/functions.sh

echo "installing cloudpie"

DEVICE=$(uname -m)

case "$DEVICE" in
armv6l)
    echo "raspberry pi"
    if apt --version; then
        sudo apt update
        sudo apt install wget agrep p7zip-full git wget curl
        wget https://downloads.rclone.org/v1.46/rclone-v1.46-linux-arm64.deb
        mv *.deb rclone.deb
        sudo dpkg -i rclone.deb
        rm rclone.deb
    fi

    ;;

x86_64)
    echo "PC"
    echo '~/cloudpie/roms' >~/.config/cloudpie/rom.conf

    if apt --version; then
        sudo apt-get update
        sudo apt install -y git agrep wget p7zip-full unrar

        wget https://github.com/ncw/rclone/releases/download/v1.46/rclone-v1.46-linux-amd64.deb
        sudo dpkg -i -y *.deb
        rm *.deb
    fi

    if pacman --version; then
        sudo pacman -Syu
        sudo pacman -S --noconfirm wget agrep p7zp git wget curl rclone
    fi

    mkdir -p ~/retroarch/retroarch

    mkdir -p ~/cloudpie/path
    rm ~/cloudpie/path/retroarch
    pushd ~/cloudpie
    mkdir save
    cd path
    wget retroarch.surge.sh/retroarch
    wget suckless.surge.sh/st
    chmod +x retroarch st

    if ./retroarch --version && ./st -version; then
        echo "retroarch and st installed successfully"
    else
        echo "retroarch and st install failed"
        exit 1
    fi

    #generate new retroarch config files
    rm -rf ~/.config/retroarch
    timeout 8 ./retroarch

    popd

    # install the fuzzy finder fzf
    pushd cloudpie/path
    wget https://github.com/junegunn/fzf-bin/releases/download/0.17.5/fzf-0.17.5-linux_amd64.tgz
    tar zxvf *.tgz
    rm *.tgz
    chmod +x ./fzf
    popd

    if pacman --version; then
        curl https://raw.githubusercontent.com/paperbenni/CloudPie/master/packages/arch.txt | sudo pacman -S -
    fi
    ;;
esac

pushd ~/
mkdir -p .config/cloudpie

mkdir retrorecords

mkdir retroarch
pushd retroarch
mkdir quicksave

popd

#update retroarch

cd cloudpie
cget update.sh platforms.txt sync.sh download.sh login.sh start.sh changeconf.sh
chmod +x update.sh sync.sh start.sh download.sh login.sh
cget bin/cloudrom bin/cloudpie
sudo mv cloudrom /bin/
sudo mv cloudpie /bin/
sudo chmod +x /bin/cloudrom /bin/cloudpie

bash update.sh

bash changeconf.sh

cd ~

mkdir -p .config/rclone
pushd .config/rclone
cget rclone.conf

clear

~/cloudpie/login.sh
popd
