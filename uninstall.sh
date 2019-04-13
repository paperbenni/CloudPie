#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb dialog/dialog.sh

cd ~

if ! [ "$1" = "-f" ]; then
    confirm "are you sure you want to uninstall cloudpie?" || exit
fi

mv cloudpie/roms ~/

rm -rf cloudpie
rm -rf retroarch
rm -rf .config/retroarch
cd /bin
sudo rm cloudrom cloudpie retroplay
