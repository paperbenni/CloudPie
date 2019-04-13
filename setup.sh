#!/bin/bash
cd

echo "installing cloudpie"

if [ -e cloudpie ]; then
    curl -s https://raw.githubusercontent.com/paperbenni/CloudPie/master/uninstall.sh | bash
fi

mkdir cloudpie
mkdir -p retroarch/retroarch retroarch/quicksave
mkdir -p .config/cloudpie
mkdir retrorecords

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie/cloudpie.sh
pb install/install.sh
pb unpack/unpack.sh

echo '~/cloudpie/roms' >.config/cloudpie/rom.conf

if [ -e ~/roms ]; then
    echo "detecting existing roms"
    mv ~/roms ~/cloudpie/roms
fi

if cat /etc/os-release | grep 'NAME' | grep -i "ubuntu"; then
    sudo add-apt-repository ppa:libretro/testing
fi

pinstall wget expect agrep p7zip-full:p7zip wget retroarch curl unrar libcg
rclone --version || curl https://rclone.org/install.sh | sudo bash

rm -rf .config/retroarch

cd cloudpie
mkdir save path

# install the fuzzy finder fzf
cd path
wget https://github.com/junegunn/fzf-bin/releases/download/0.17.5/fzf-0.17.5-linux_amd64.tgz
unpack *.tgz
rm *.tgz
wget suckless.surge.sh/st
wget roverfile.surge.sh/rover
chmod +x st fzf rover

cd

cd cloudpie
cget play.sh update.sh platforms.txt sync.sh download.sh login.sh start.sh changeconf.sh
chmod +x *.sh
cget bin/cloudrom bin/cloudpie bin/retroplay
sudo mv retroplay /bin/
sudo mv cloudrom /bin/
sudo mv cloudpie /bin/
sudo chmod +x /bin/cloudrom /bin/cloudpie /bin/retroplay

cget formats.txt

if [ "$1" = "nocores" ]; then
    echo "skipping cores"
else
    bash update.sh
fi

bash changeconf.sh

cd

mkdir -p .config/rclone
cd .config/rclone

if ! cat rclone.conf | grep '[cloudpie]'; then
    echo "adding mega storage"
    curl https://raw.githubusercontent.com/paperbenni/CloudPie/master/rclone.conf >>rclone.conf
fi
