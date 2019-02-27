#!/bin/bash

if ! rclone --version; then
    echo "please install rclone version 1.46 or higher to use the sync feature"
    exit
fi

USERNAME=$(cat ~/cloudpie/username.txt)
while :; do
    echo "checking password for $USERNAME"
    MEGAPASSWORD=$(rclone cat mega:"$USERNAME"/password.txt)
    USERPASSWORD=$(cat ~/cloudpie/password.txt)
    if [ "$MEGAPASSWORD" = "$USERPASSWORD" ]; then
        echo "passowrd correct"
        rm -rf ~/cloudpie/save
        mkdir -p ~/cloudpie/save
        sleep 1
        echo "mounting saves"
        if ! pgrep rclone >/dev/null; then
            rclone mount mega:"$USERNAME/save" ~/cloudpie/save
        else
            echo "rclone already running, trying again in 5 minutes" 
            sleep 5m
        fi
        sleep 2
    else
        echo "wrong password, type in a new one"
    fi
done
