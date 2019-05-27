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

console="$1"
zerocheck "$console"
game="$2"
zerocheck "$game"

#special commands that are not games
if ! [ -z "$1" ]; then
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

cd ~/cloudpie
echo "installing game"
test -e repos/"$console".txt || romupdate
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
