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
echo "$PASSWORD" >~/cloudpie/password.txt

echo "$USERNAME" >username.txt
if rclone lsd mega:"$USERNAME"; then
    echo "user exists, checking password"
    MEGAPASSWORD=$(rclone cat mega:"$USERNAME"/password.txt)
    if [ "$MEGAPASSWORD" = "$PASSWORD" ]; then
        echo "login sucessfull"
        sleep 2
    else
        echo "wrong password"
        sleep 2
        exit 1
    fi
else
    echo "user not found, creating new account"
    rclone mkdir mega:"$USERNAME"
    rclone mkdir mega:"$USERNAME"/save
    echo "cloud" >cloud.txt
    rclone copy cloud.txt mega:"$USERNAME/save/"
    rm cloud.txt
    rclone copy ~/cloudpie/password.txt mega:"$USERNAME/"
fi

popd
