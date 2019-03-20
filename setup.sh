#!/bin/bash
pushd ~
rm -rf cloudpie
mkdir cloudpie

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie/cloudpie.sh
pb install/install.sh
pb unpack/unpack.sh

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

    if cat /etc/os-release | grep 'NAME' | grep -i "ubuntu"; then
        sudo add-apt-repository ppa:libretro/testing
    fi

    pinstall wget agrep p7zip-full:p7zip wget retroarch curl unrar libcg
    rclone --version || curl https://rclone.org/install.sh | sudo bash

    mkdir -p ~/retroarch/retroarch

    mkdir -p ~/cloudpie/path
    pushd ~/cloudpie || exit
    mkdir save

    #generate new retroarch config files
    rm -rf ~/.config/retroarch
    timeout 5 ./retroarch

    popd

    # install the fuzzy finder fzf
    pushd cloudpie/path
    wget https://github.com/junegunn/fzf-bin/releases/download/0.17.5/fzf-0.17.5-linux_amd64.tgz
    unpack *.tgz
    rm *.tgz
    chmod +x ./fzf
    popd

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
cget play.sh update.sh platforms.txt sync.sh download.sh login.sh start.sh changeconf.sh
chmod +x *.sh
cget bin/cloudrom bin/cloudpie bin/retroplay
sudo mv retroplay /bin/
sudo mv cloudrom /bin/
sudo mv cloudpie /bin/
sudo chmod +x /bin/cloudrom /bin/cloudpie /bin/retroplay

cget formats.txt

if ! [ "$1" = "nocores" ]; then
    bash update.sh
else
    echo "skipping cores"
fi

cd ~/cloudpie/path
wget suckless.surge.sh/st
chmod +x st

bash changeconf.sh

cd ~

mkdir -p .config/rclone
pushd .config/rclone

if ! cat rclone.conf | grep 'cloudpie'; then
    curl https://raw.githubusercontent.com/paperbenni/CloudPie/master/rclone.conf >>rclone.conf
fi

popd
