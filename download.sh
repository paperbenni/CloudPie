#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)

pb cloudpie/cloudpie.sh
pb proton/proton.sh
pb unpack/unpack.sh

function checkscript() {
    #statements
    if ! dialog --version >/dev/null; then
        echo "dialog must be installed in order for this to work"
        exit
    fi

    if ! curl cht.sh &>/dev/null; then
        echo "you need internet to do this"
        exit 1
    fi
}

checkscript

function mkcd() {
    if ! [ -e "$1" ]; then
        mkdir "$1"
    fi
    cd "$1"
}
urldecode() {
    echo -e "$(sed 's/+/ /g;s/%\(..\)/\\x\1/g;')"
}

function repoload() {
    # $1 is the link
    # $2 is the repo file name
    # $3 is the system name
    # $4 is the file extension
    rm "$2".txt
    echo "updating $(echo $1 | urldecode) repos"

    curl https://the-eye.eu/public/rom/$1/ >"$2".2.tmp
    if ! grep "z64" <"$2.2.tmp"; then
        curl http://the-eye.eu/public/rom/$1/ >"$2".2.tmp
    fi

    #decodes spaces and other characters from html links
    sed -n 's/.*href="\([^"]*\).*/\1/p' "$2".2.tmp >"$2.tmp"
    rm "$2.2.tmp"
    cat "$2".tmp | urldecode >"$2".txt
    rm "$2".tmp
    # add the link prefix as the last line
    echo "https://the-eye.eu/public/rom/$1/" >>"$2".txt
    sleep 1

}

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
    if [ -z "$EXITTHIS" ]; then
        exit 0
    else
        echo "installing game"
    fi
fi

if ! [ -e ~/cloudpie/repos/n64.txt ]; then
    romupdate
fi

cd ~/cloudpie

echo "for what console would you like your game?"
PS3="Select platform: "

console=$(cat platforms.txt | ~/cloudpie/path/fzf)
zerocheck "$console"

pushd repos
LINK=$(cat $console.txt | tail -1)

game=$(cat "$console".txt | ~/cloudpie/path/fzf)
zerocheck "$game"

popd

echo "downloading $game"

mkdir roms
pushd "roms"
mkcd "$console"
GAMENAME=${game%.*}

if ls ./"$GAMENAME".* 1>/dev/null 2>&1; then
    echo "game $GAMENAME already exists"
else
    echo "activating vpn"
    proton
    sleep 2
    wget "$LINK$game" -q --show-progress
    sudo pvpn -d
    unpack "$game" rm
fi

popd

echo "enjoy the game!"
sleep 3
