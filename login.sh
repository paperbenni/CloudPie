#!/usr/bin/env bash
if ! rclone --version; then
    echo "you need rclone >= 1.46 installed"
fi

mkdir -p ~/cloudpie
pushd ~/cloudpie

echo "what's your username?"
read USERNAME

echo "enter password"
read PASSWORD

rm username.txt password.txt

echo "$USERNAME" >username.txt
if rclone lsd mega:"$USERNAME" &>/dev/null &&
    rclone cat mega:"$USERNAME"/password.txt; then
    echo "user exists, checking password"
    MEGAPASSWORD=$(rclone cat mega:"$USERNAME"/password.txt)
    if [ "$MEGAPASSWORD" = "$PASSWORD" ]; then
        echo "login sucessfull"
        sleep 2
    else
        echo "type in the correct password or choose another username please"
    fi
else
    echo "user not found, creating new account"
    echo "$PASSWORD" >~/cloudpie/password.txt
    rclone mkdir mega:"$USERNAME"
    rclone copy ~/cloudpie/password.txt mega:"$USERNAME/"
fi

popd
