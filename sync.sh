#!/bin/bash
pgrep rclone && exit
command -v rclone &&
    source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh) || exit

pb rclone/rclone
pb rclone/login
pb dialog/dmenu

if [ -e $HOME/cloudpie/cloud.txt ]; then
    echo "already connected"
    exit
else
    echo "no existing connection found"
fi

dpop "$(figlet -w 200 CloudPie\ connecting...)" &
rclogin cloudpie

pushd .

while ! cd ~/cloudpie/save; do
    rmdpop
    sleep 0.5
    echo "unmounting saves"
    if ! dsudo umount ~/cloudpie/save; then
        dsudo umount -l ~/cloudpie/save
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
    rclone lsd "cloudpie:$RNAME"/save || rclone mkdir "cloudpie:$RNAME"/save
    rclone cat "cloudpie:$RNAME"/save/cloud.txt || rclone touch "cloudpie:$RNAME"/save/cloud.txt
    rmount save ~/cloudpie/save
    sleep 2
done

pkill rclone.sh
pkill sync.sh
