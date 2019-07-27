#!/bin/bash
cd

if [ -e cloudpie ]; then
    curl -s https://raw.githubusercontent.com/paperbenni/CloudPie/master/uninstall.sh | bash
fi
#paperbenni imports
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie
pb install
pb unpack
pb proton
echo "installing cloudpie"

mkdir cloudpie
mkdir -p retroarch/retroarch retroarch/quicksave
mkdir -p .config/cloudpie
mkdir retrorecords


echo '~/cloudpie/roms' >.config/cloudpie/rom.conf

if [ -e ~/roms ]; then
    echo "detecting existing roms"
    mv ~/roms ~/cloudpie/
fi

#add retroarch daily ppa if ubuntu
if cat /etc/os-release | grep 'NAME' | grep -i "ubuntu"; then
    sudo add-apt-repository ppa:libretro/testing
fi

#install dependencies
pinstall wget expect agrep p7zip-full:p7zip wget retroarch curl unrar \
    libcg openvpn dialog python svn:subversion dmenu
    
rclone --version || curl https://rclone.org/install.sh | sudo bash
#protonvpn
sudo wget -O protonvpn-cli.sh https://raw.githubusercontent.com/ProtonVPN/protonvpn-cli/master/protonvpn-cli.sh
sudo chmod +x protonvpn-cli.sh
sudo ./protonvpn-cli.sh --install
sudo rm protonvpn-cli.sh

rm -rf .config/retroarch

cd cloudpie
mkdir save path


cd

cd cloudpie
cget play.sh update.sh platforms.txt sync.sh download.sh start.sh changeconf.sh
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
