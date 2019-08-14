#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
cd
if [ -e cloudpie ]; then
    curl -s https://raw.githubusercontent.com/paperbenni/CloudPie/master/uninstall.sh | bash
fi
cd
mkdir -p retroarch/retroarch retroarch/quicksave
mkdir cloudpie
mkdir -p .config/cloudpie
mkdir retrorecords

#paperbenni imports
pb cloudpie
pb install
pb unpack
pb proton
pb git
pb rclone
pb rclone/login
pb logo
logocloudpie
echo ""
echo "installing cloudpie"

cd .cache
git clone "https://github.com/paperbenni/CloudPie.git"
cd CloudPie
[ "$1" = "nocores" ] || bash update.sh
# console configuration like link and core
mv consoles ~/cloudpie/
# core options like resolution
mkdir -p ~/.config/retroarch
mv config/* ~/.config/retroarch/
rm setup.sh test.sh uninstall.sh
chmod +x *.sh
mv *.sh ~/cloudpie/

sudo ln -s ~/cloudpie/start.sh /usr/bin/cloudpie
sudo ln -s ~/cloudpie/play.sh /usr/bin/retroplay
sudo ln -s ~/cloudpie/download.sh /usr/bin/cloudrom
cd

echo '~/cloudpie/roms' >.config/cloudpie/rom.conf

# roms backed up by uninstaller
if [ -e ~/roms ]; then
    echo "detecting existing roms"
    mv ~/roms ~/cloudpie/
fi

#add retroarch daily ppa if ubuntu
if cat /etc/os-release | grep 'NAME' | grep -i "ubuntu"; then
    sudo add-apt-repository ppa:libretro/testing
fi

#install dependencies
pinstall wget expect agrep p7zip-full:p7zip \
    wget retroarch curl unrar libcg openvpn dialog \
    python

# install suckless tools
if ! (command -v st && command -v dmenu); then
    curl https://raw.githubusercontent.com/paperbenni/suckless/master/install.sh | bash
fi

rclone --version || curl https://rclone.org/install.sh | sudo bash

#protonvpn
sudo wget -O protonvpn-cli.sh https://raw.githubusercontent.com/ProtonVPN/protonvpn-cli/master/protonvpn-cli.sh
sudo chmod +x protonvpn-cli.sh
sudo ./protonvpn-cli.sh --install
sudo rm protonvpn-cli.sh

rm -rf .config/retroarch
bash ~/cloudpie/changeconf.sh
bash cache.sh
cd
rm -rf .cache/CloudPie
rcloud cloudpie

echo "installation was successful!"
