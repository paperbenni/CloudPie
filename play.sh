#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie/cloudpie.sh

PS3="what platform does your game run on?"

if ! [ -e "$HOME/cloudpie/save/cloud.txt" ]; then
    echo "no existing connection found"
    ~/cloudpie/sync.sh &
    sleep 10
    pushd ~/cloudpie/save
    if ! [ -e cloud.txt ]; then
        echo "connection to the internet failed, closing app to avoid data loss"
        exit
    fi
    popd
fi

pushd ~/cloudpie/roms
rm formatcache.txt &>/dev/null

PLATFORM=$(ls | ~/cloudpie/path/fzf)
zerocheck "$PLATFORM"

echo "$PLATFORM"
pushd "$PLATFORM"

while read p; do
    if echo "$p" | grep "$PLATFORM"; then
        FILEENDING=${p##*:}
        ls *.$FILEENDING >>formatcache.txt
    fi
done <~/cloudpie/formats.txt

GAME=$(cat formatcache.txt | ~/cloudpie/path/fzf)
zerocheck "$GAME"

rm formatcache.txt

if [ -z "$GAME" ]; then
    echo "operation canceled"
    exit 0
    break
fi
echo "starting $GAME"
openrom "$HOME/cloudpie/roms/$PLATFORM/$GAME" "$PLATFORM"
echo "hope you had fun"
