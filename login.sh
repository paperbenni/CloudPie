#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb rclone/login.sh

if ! rclone --version; then
    echo "you need rclone >= 1.46 installed"
    exit
fi

mkdir -p ~/cloudpie
pushd ~/cloudpie

echo "what's your username?"
read USERNAME

echo "enter password"
read PASSWORD

rm username.txt password.txt
echo "$PASSWORD" >~/cloudpie/password.txt
echo "$USERNAME" >~/cloudpie/username.txt

rlogin cloudpie "$USERNAME" "$PASSWORD"

popd
