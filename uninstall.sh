#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb dialog

cd

mv cloudpie/roms ~/

echo "looking for saves"

pkill sync.sh
pkill rclone

if [ -e ~/cloudpie/save/cloud.txt ]; then
    echo "unmounting saves failed"
    exit 1
fi

rm -rf cloudpie
rm -rf retroarch
rm -rf .config/retroarch

cd /usr/bin/
sudo unlink cloudrom cloudpie retroplay
