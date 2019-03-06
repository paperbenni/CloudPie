#!/bin/bash
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

USERNAME=$(cat ~/cloudpie/username.txt)
while :; do
    echo "checking password for $USERNAME"
    MEGAPASSWORD=$(rclone cat mega:"$USERNAME"/password.txt)
    USERPASSWORD=$(cat ~/cloudpie/password.txt)
    if [ "$MEGAPASSWORD" = "$USERPASSWORD" ]; then
        echo "password correct"
        if ! [ -e $HOME/cloudpie/save/cloud.txt ]; then
            rm -rf ~/cloudpie/save
        fi
        mkdir -p ~/cloudpie/save
        sleep 1
        echo "mounting saves for $USERNAME"
        rclone mount mega:"$USERNAME/save" ~/cloudpie/save
        sleep 5m

        sleep 2
    else
        echo "wrong password, type in a new one"
    fi
done
