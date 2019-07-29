#!/usr/bin/env bash

echo "building cloudpie console cache"
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb grep
cd
if ! [ -d cloudpie/consoles ]; then
    echo "console config not found"
    return 1
fi

cd cloudpie/consoles
mkdir cache &>/dev/null

for i in *; do
    if ! [ -d "$i" ]; then
        CONSOLENAME=$(cat "$i" | grep 'name' | betweenquotes)
        echo ${i%.*} >cache/"$CONSOLENAME"
    fi
done

echo "cache built"
