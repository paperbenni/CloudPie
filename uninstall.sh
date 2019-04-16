#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb dialog/dialog.sh

cd ~

if ! [ "$1" = "-f" ]; then
    confirm "are you sure you want to uninstall cloudpie?" || exit
fi

mv cloudpie/roms ~/

echo "looking for saves"
if pgrep sync.sh || pgrep rclone; then
    pkill sync.sh
    pkill rclone
fi

if [ -e ~/cloudpie/save/cloud.txt ]; then
    echo "unmounting saves failed"
    exit 1
fi

rm -rf cloudpie
rm -rf retroarch
rm -rf .config/retroarch
cd /bin
sudo rm cloudrom cloudpie retroplay
