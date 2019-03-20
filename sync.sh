#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)

pb rclone/rclone.sh
pb rclone/login.sh

if pgrep rclone >/dev/null; then
    echo "rclone already running!"
    exit
fi

if ! rclone --version; then
    echo "please install rclone version 1.46 or higher to use the sync feature"
    exit
fi

if [ -e $HOME/cloudpie/cloud.txt ]; then
    echo "already connected"
    exit
else
    echo "no existing connection found"
fi

if ! rclogin cloudpie "$(cat ~/cloudpie/username.txt)" "$(cat ~/cloudpie/password.txt)"; then
    echo "mega login failed"
    exit 1
fi

while :; do
    if ! [ -e $HOME/cloudpie/save/cloud.txt ]; then
        rm -rf ~/cloudpie/save
    fi
    mkdir -p ~/cloudpie/save
    sleep 1
    echo "mounting saves for $RNAME"
    rmount save ~/cloudpie/save
    sleep 2
done
