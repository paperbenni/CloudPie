#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh) || exit

pb rclone/rclone
pb rclone/login

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

if ! rclogin cloudpie
then
  echo "please enter the right password or change account"
  exit 1
fi

pushd .

while ! cd ~/cloudpie/save; do
    echo "unmounting saves"
    if ! sudo umount ~/cloudpie/save; then
        sudo umount -l ~/cloudpie/save
    fi

    sleep 2
done

while :; do
    if ! [ -e $HOME/cloudpie/save/cloud.txt ]; then
        rm -rf ~/cloudpie/save
    fi
    mkdir -p ~/cloudpie/save
    sleep 1
    echo "mounting saves for $RNAME"
    rclone lsd "$RCLOUD:$RNAME"/save || rclone mkdir "$RCLOUD:$RNAME"/save
    rclone cat "$RCLOUD:$RNAME"/save/cloud.txt || rclone touch "$RCLOUD:$RNAME"/save/cloud.txt
    rmount save ~/cloudpie/save
    sleep 2
done

pkill rclone.sh
pkill sync.sh
