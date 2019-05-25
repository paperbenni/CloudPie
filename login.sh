#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb rclone/login.sh
pb dialog

if ! command -v rclone; then
    echo "you need rclone >= 1.46 installed"
    exit
fi

mkdir -p ~/cloudpie
pushd ~/cloudpie

USERNAME=$(textbox "username")
PASSWORD=$(textbox "password")

echo "$PASSWORD" >~/cloudpie/password.txt
echo "$USERNAME" >~/cloudpie/username.txt

rclogin cloudpie "$USERNAME" "$PASSWORD"

popd
