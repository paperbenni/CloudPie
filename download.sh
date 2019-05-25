#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)

pb cloudpie
pb proton
pb unpack
pb bash

if ! dialog --version >/dev/null; then
    echo "dialog must be installed in order for this to work"
    exit
fi

if ! curl cht.sh &>/dev/null; then
    echo "you need internet to do this"
    exit 1
fi

function romupdate() {
    if ! curl cht.sh &>/dev/null; then
        echo "no internet"
        exit
    fi
    mkdir -p ~/cloudpie/repos
    pushd ~/cloudpie/repos

    repoload 'Nintendo%2064/Roms' n64
    repoload 'SNES' snes
    repoload 'Playstation/Games/NTSC' psx
    repoload 'Nintendo%20Gameboy%20Advance' gba
    repoload 'Nintendo%20DS' ds
    repoload 'NES' nes
    repoload 'Nintendo%20Gameboy%20Color' gbc

    popd
}

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

echo "installing game"

test -e ~/cloudpie/repos/n64.txt || romupdate

cd ~/cloudpie

echo "Select console"

console=$(cat platforms.txt | ~/cloudpie/path/fzf)
zerocheck "$console"

pushd repos
LINK=$(cat $console.txt | tail -1)

game=$(cat "$console".txt | ~/cloudpie/path/fzf)
zerocheck "$game"

popd

echo "downloading $game"

mkdir roms
cd "roms" || exit
mkcd "$console"
GAMENAME=${game%.*}

if ls ./"$GAMENAME".* &>/dev/null; then
    echo "game $GAMENAME already exists"
else
    echo "activating vpn"
    proton
    sleep 2
    wget "$LINK$game" -q --show-progress
    sudo pvpn -d
    unpack "$game" rm
fi

echo "enjoy the game!"
sleep 3
