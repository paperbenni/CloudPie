#!/bin/bash

echo "starting CloudPie"
if ! [ -e "$HOME/cloudpie/save/cloud.txt" ]; then
    ~/cloudpie/sync.sh &
    sleep 2
    while ! [ -e ~/cloudpie/save/cloud.txt ]; do
        echo "waiting for cloud saves"
        sleep 2
    done

fi

retroarch
