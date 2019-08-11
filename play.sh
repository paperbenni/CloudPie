#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie
pb alias

#connect to cloud storage and wait for the confirmation file
cloudconnect

cd ~/cloudpie
#choose console
cd consoles/cache

# read out the config file chosen by dmenu
PLATFORM=$(cat "$(ls | dm)")
cd ~/cloudpie
zerocheck "$PLATFORM"
echo "PLATFORM $PLATFORM"
if ! [ -e "repos/$PLATFORM.txt" ]; then
    romupdate
fi

GAME="$(cat repos/$PLATFORM.txt | dm)"
echo "selected game $GAME"
zerocheck "$GAME"

mkcd roms/"$PLATFORM"

GNAME="${GAME%%.*}"
echo "game name $GNAME"
[ -z "$1" ] || echo "optional args $1"
if ! ls "$GNAME".*; then
    ~/cloudpie/download.sh "$PLATFORM" "$GAME" "$1"
fi

FORMATS=$(getconsole "$PLATFORM" 'format')

IFS2=$IFS
IFS=','
for F in $FORMATS; do
    if ! [ -e "$GNAME.$F" ]; then
        echo "format $F not found"
        continue
    fi

    echo "found $F, starting $GAME"
    openrom "$GNAME.$F" "$PLATFORM"
    echo "hope you had fun"
    break
done
IFS="$IFS2"
