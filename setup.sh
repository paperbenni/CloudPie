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
bash changeconf.sh
[ "$1" = "nocores" ] || bash update.sh
mv consoles ~/cloudpie/
rm setup.sh test.sh uninstall.sh
chmod +x *.sh
mv *.sh ~/cloudpie/

cd ~/cloudpie
sudo ln -s start.sh /usr/bin/cloudpie
sudo ln -s play.sh /usr/bin/retroplay
sudo ln -s download.sh /usr/bin/cloudrom
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
    python dmenu

rclone --version || curl https://rclone.org/install.sh | sudo bash

#protonvpn
sudo wget -O protonvpn-cli.sh https://raw.githubusercontent.com/ProtonVPN/protonvpn-cli/master/protonvpn-cli.sh
sudo chmod +x protonvpn-cli.sh
sudo ./protonvpn-cli.sh --install
sudo rm protonvpn-cli.sh

rm -rf .config/retroarch

cd
rm -rf .cache/CloudPie
rcloud cloudpie

echo "installation was successful!"
