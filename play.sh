#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie
pb bash

#connect to cloud storage and wait for the confirmation file
cloudconnect

cd ~/cloudpie
#choose console
cd cache
PLATFORM=$(cat $(ls | dm))
cd ..

zerocheck "$PLATFORM"
echo "$PLATFORM"
if ! [ -e "repos/$PLATFORM.txt" ]; then
    romupdate
fi

GAME="$(cat repos/$PLATFORM.txt | dm)"
zerocheck "$GAME"

mkcd roms/"$PLATFORM"
GNAME=${GAME%.*}
if ! ls $GNAME.*; then
    ~/cloudpie/download.sh "$PLATFORM" "$GAME"
fi

FORMATS=$(getconsole "$PLATFORM" 'format')

for F in "$FORMATS"; do
    if ! [ -e "$GNAME.$F" ]; then
        echo "format $F not found"
        continue
    fi

    echo "starting $GAME"
    openrom "$GNAME.$F" "$PLATFORM"
    echo "hope you had fun"
    break
done
