#!/bin/bash

echo "starting CloudPie"
if ! [ -e "$HOME/cloudpie/save/cloud.txt" ]; then
    ~/cloudpie/sync.sh &
    sleep 2
    while ! [ -e ~/cloudpie/save/cloud.txt ]; do
        if ! pgrep dialog &>/dev/null; then
            echo "waiting for cloud saves"
        fi
        sleep 2
    done

fi

retroarch
