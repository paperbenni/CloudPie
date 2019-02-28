#!/bin/bash

echo "starting CloudPie"
~/cloudpie/sync.sh &
sleep 5
if ! [ -e ~/cloudpie/save/cloud.txt ]; then
    echo "connection to the internet failed, closing app to avoid data loss"
    exit
fi
~/cloudpie/path/retroarch
