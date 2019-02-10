#!/bin/bash

if ! rclone --version; then
    echo "please install rclone version 1.46 or newer to use the sync feature"
    exit
fi

USERNAME=$(cat ~/cloudpie/username.txt)
while :; do
    MEGAPASSWORD
    USERPASSWORD
    if [ ]
    rclone mount mega:"$USERNAME/retroarch" ~/retroarch/
    sleep 2
done
