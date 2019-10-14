#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie
pb alias
pb dialog/dmenu
#connect to cloud storage and wait for the confirmation file
dpop "$(figlet -w 200 CloudPie\ connecting...)"
cloudconnect
rmdpop
cd
cd cloudpie/consoles/cache

# read out the config file chosen by dmenu
PLATFORM=$(cat "$(ls | dm)")
cd ~/cloudpie
zerocheck "$PLATFORM"

if ! cat consoles/$PLATFORM.conf | grep "link"; then
    echo "console $PLATFORM has no repos, using local files"
    cd ~/cloudpie/roms/$PLATFORM
    GAME="$(ls | dm)"
    openrom "$GAME" "$PLATFORM"
else
    echo "repo link found: "
    cat consoles/$PLATFORM.conf | grep "link"
    echo "PLATFORM $PLATFORM"
    if ! [ -e "repos/$PLATFORM.txt" ]; then
        dpop "$(figlet fetching)" 5
        romupdate
    fi

    GAME="$(cat repos/$PLATFORM.txt | dm)"
    echo "selected game $GAME"
    zerocheck "$GAME"

    mkcd roms/"$PLATFORM"

    GNAME="${GAME%.*}"
    echo "game name $GNAME"
    [ -z "$1" ] || echo "optional args $1"
    if ! ls "$GNAME".*; then
        ~/cloudpie/cloudrom.sh "$PLATFORM" "$GAME" "$1"
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
        break
    done
    IFS="$IFS2"
fi

echo "hope you had fun"
