#!/bin/bash

############################################
## remove cloudpie but keep roms          ##
############################################

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb dialog

cd

mv cloudpie/roms ~/

while pgrep rclone || pgrep sync.sh; do
    pkill sync.sh
    pkill rclone
    sleep 3
done

if [ -e ~/cloudpie/save/cloud.txt ]; then
    echo "unmounting saves failed"
    exit 1
fi

rm -rf cloudpie
mv ~/retroarch ~/.cache/retroarch
rm -rf .config/retroarch

cd /usr/bin/
sudo unlink cloudrom
sudo unlink cloudpie
sudo unlink cloudarch
