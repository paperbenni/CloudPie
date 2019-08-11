#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
zerocheck "$1"
zerocheck "$2"

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

if [ "$3" = "novpn" ]; then
    NOPROTON="true"
    echo "deactivating vpn"
fi

console="$1"
game="$2"

cd ~/cloudpie
echo "installing game $game"
CLINK=$(getconsole $console link)
if ! echo $CLINK | grep 'http'; then
    LINK="https://the-eye.eu/public/rom/$CLINK"
else
    LINK="$CLINK"
fi

echo "downloading $game"

mkcd roms/"$console"
GAMENAME=${game%.*}

if ls ./"$GAMENAME".* &>/dev/null; then
    echo "game $GAMENAME already exists"
else
    echo "activating vpn"
    if [ -z "$NOPROTON" ]; then
        dsudo echo lal
        proton
        sleep 2
    fi
    URGAME=$(urlencode "$game")
    WCOMMAND="wget \"$LINK/$URGAME\" -q --show-progress"
    echo "$WCOMMAND"
    st -e sh -c "$WCOMMAND"
    [ -z "$NOPROTON" ] && dsudo pvpn -d
    unpack "$game" rm
fi

echo "enjoy the game!"
sleep 3
