#!/bin/bash
source ~/cloudpie/functions.sh

PS3="what platform does your game run on?"

pushd ~/cloudpie/roms
rm formatcache.txt &> /dev/null
select PLATFORM in $(ls); do
    echo "$PLATFORM"
    pushd "$PLATFORM"

    while read p; do
        if echo "$p" | grep "$PLATFORM"; then
            FILEENDING=${p##*:}
            ls *.$FILEENDING >>formatcache.txt
        fi
    done <~/cloudpie/formats.txt

    GAME=$(cat formatcache.txt | ~/cloudpie/path/fzf)
    rm formatcache.txt
    if [ -z "$GAME" ]; then
        echo "operation canceled"
        exit 0
        break
    fi
    echo "starting $GAME"
    openrom "$HOME/cloudpie/roms/$PLATFORM/$GAME" "$PLATFORM"
    break
done
