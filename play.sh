#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie
pb bash

#connect to cloud storage and wait for the confirmation file
if ! [ -e "$HOME/cloudpie/save/cloud.txt" ]; then
    echo "no existing connection found"
    ~/cloudpie/sync.sh &
    sleep 10
    pushd ~/cloudpie/save

    while ! test -e cloud.txt; do
        if ! pgrep dmenu; then
            echo "waiting for cloud saves"
        fi
        sleep 5
    done

    popd
fi

cd ~/cloudpie
#choose console
PLATFORM=$(cat platforms.txt | dmenu -l 30)
zerocheck "$PLATFORM"
echo "$PLATFORM"
GAME="$(cat repos/$PLATFORM.txt | dmenu -l 30)"
zerocheck "$GAME"

mkcd roms/"$PLATFORM"
GNAME=${GAME%.*}
if ! ls $GNAME.*; then
    ~/cloudpie/download.sh "$PLATFORM" "$GAME"
fi

while read p; do
    echo "$p"
    if echo "$p" | grep "$PLATFORM"; then
        FILEENDING=$(echo "$p" | egrep -o ':.*' | egrep -o '[^:].*')
        GAMENAME=${GAME%.*}.$FILEENDING
        if [ -e "$GAMENAME" ]; then
            echo "starting $GAME"
            openrom "$HOME/cloudpie/roms/$PLATFORM/$GAMENAME" "$PLATFORM"
            echo "hope you had fun"
            break
        fi
    fi
done <~/cloudpie/formats.txt
