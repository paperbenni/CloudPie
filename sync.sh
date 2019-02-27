#!/bin/bash

if ! rclone --version; then
    echo "please install rclone version 1.46 or higher to use the sync feature"
    exit
fi

USERNAME=$(cat ~/cloudpie/username.txt)
while :; do
    MEGAPASSWORD=$(rclone cat mega:"$USERNAME"/password.txt)
    USERPASSWORD=$(cat ~/cloudpie/password.txt)
    if [ "$MEGAPASSWORD" = "$USERPASSWORD" ]; then
        rclone mount mega:"$USERNAME/retroarch/save" ~/cloudpie/save
        sleep 2
    else
        echo "wrong password, type in a new one"
    fi
done
