#!/bin/bash

echo "starting CloudPie"
~/cloudpie/sync.sh &
sleep 5
pushd ~/cloudpie/save
if ! [ -e cloud.txt ]; then
    echo "connection to the internet failed, closing app to avoid data loss"
    exit
fi
popd
~/cloudpie/path/retroarch
