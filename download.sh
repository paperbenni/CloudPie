#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)

pb cloudpie
pb proton
pb unpack
pb bash
pb dialog
pb dialog/dmenu

if ! curl cht.sh &>/dev/null; then
    echo "you need internet to do this"
    exit 1
fi

#special commands that are not games
if [ -n "$1" ]; then
    case "$1" in
    update)
        romupdate
        ;;
    cores)
        curl https://raw.githubusercontent.com/paperbenni/CloudPie/master/update.sh | bash
        ;;
    version)
        echo "veeery early beta"
        ;;
    help)
        curl https://raw.githubusercontent.com/paperbenni/CloudPie/master/help.txt
        ;;
    clean)
        echo "clearing cache"
        rm -rf ~/retroarch/cache
        rm -rf ~/cloudpie/repos
        ;;
    *)
        EXITTHIS=1
        ;;
    esac
    test -z "$EXITTHIS" && exit 0

fi

# choose platform and game
if [ -n "$1" ]; then
    console="$1"
else
    console=$(cat ~/cloudpie/platforms.txt | dmenu)
fi
zerocheck "$console"

test -e repos/"$console".txt || romupdate
if [ -n "$2" ]; then
    game="$2"
else
    game=$(cat ~/cloudpie/repos/$console.txt | dmenu)
fi
zerocheck "$game"

cd ~/cloudpie
echo "installing game"
LINK=$(cat repos/$console.txt | tail -1)

echo "downloading $game"

mkcd roms/"$console"
GAMENAME=${game%.*}

if ls ./"$GAMENAME".* &>/dev/null; then
    echo "game $GAMENAME already exists"
else
    echo "activating vpn"
    dsudo echo lal
    proton
    sleep 2
    wget "$LINK"$(urlencode "$game") --show-progress
    dsudo pvpn -d
    unpack "$game" rm
fi

echo "enjoy the game!"
sleep 3
