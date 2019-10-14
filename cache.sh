#!/usr/bin/env bash

#####################################################
## caches console name abbreviations in text files ##
#####################################################

echo "building cloudpie console cache"
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb grep
pb cloudpie

cd

if ! [ -d cloudpie/consoles ]; then
    echo "console config not found"
    return 1
fi

cd cloudpie/consoles
mkdir cache &>/dev/null

for i in *; do
    if ! [ -d "$i" ]; then
        CONSOLENAME=$(getconsole "${i%.*}" 'name')
        echo "console $CONSOLENAME"
        echo ${i%.*} >cache/"$CONSOLENAME"
    fi
done

echo "cache built"
