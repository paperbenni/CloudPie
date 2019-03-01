#!/bin/bash

echo "starting CloudPie"
if ! [ -e "$HOME/cloudpie/save/cloud.txt" ]; then
    ~/cloudpie/sync.sh &
    sleep 10
    pushd ~/cloudpie/save
    if ! [ -e cloud.txt ]; then
        echo "connection to the internet failed, closing app to avoid data loss"
        exit
    fi
    popd
fi

~/cloudpie/path/retroarch
