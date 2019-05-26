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
        echo "waiting for cloud saves"
        sleep 5
    done

    popd
fi

pushd ~/cloudpie/roms

#choose console
PLATFORM=$(ls | dmenu -l 30)
zerocheck "$PLATFORM"

echo "$PLATFORM"
pushd "$PLATFORM"

#get a list of all files ending with the extension for the console

FILEENDINGS=$(cat ~/cloudpie/formats.txt | grep "$PLATFORM" |
    egrep -o ':.*' | egrep -o '[^:].*')

while read -r line; do
    echo "file extension $line"
    ls *.$line >>gamecache.txt
done <<<"$FILEENDINGS"

GAME=$(cat gamecache.txt | dmenu -l 30)
rm gamecache.txt

zerocheck "$GAME"

if [ -z "$GAME" ]; then
    echo "operation canceled"
    exit 0
    break
fi

echo "starting $GAME"
openrom "$HOME/cloudpie/roms/$PLATFORM/$GAME" "$PLATFORM"
echo "hope you had fun"
