#!/bin/bash
function checkscript() {
    #statements
    if ! dialog --version; then
        echo "dialog must be installed in order for this to work"
        exit
    fi

    if ! curl cht.sh; then
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

function repoload() {
    # $1 is the link
    # $2 is the repo file name
    # $3 is the system name
    # $4 is the file extension
    rm "$2".txt
    echo "updating $3 repos"
    curl https://the-eye.eu/public/rom/$1/ >"$2".tmp
    cat "$2".tmp | sed -e 's/.*>\(.*\)<\/a>.*/\1/' >"$2".tmp2
    cat "$2".tmp2 | grep ".$4" >"$2".txt
    rm "$2".tmp2
    rm "$2".tmp
    echo "https://the-eye.eu/public/rom/$1/" >>"$2".txt
    sleep 1

}

function romupdate() {
    if ! curl cht.sh >/dev/null; then
        echo "no internet"
        exit
    fi
    mkdir -p ~/cloudpie/repos
    pushd ~/cloudpie/repos

    repoload 'Nintendo%2064/Roms' n64 "Nintendo 64" z64
    repoload 'SNES' snes "Super Nintendo Entertainment System" zip
    repoload 'Playstation/Games/NTSC' psx "Play Station 1" zip
    repoload 'Nintendo Gameboy Advance' gba "Game Boy Advance" zip
    repoload 'Nintendo%20DS' ds "Nintendo DS" 7z

    popd
}

function unpack() {
    echo "unpacking $1"
    if ! [ -e "$1" ]; then
        echo "file not found"
        exit 1
    fi
    FILEFORMAT=${1#*.}
    case "$FILEFORMAT" in
    zip)
        unzip "$1"
        ;;
    7z)
        7za x ./"$1"
        ;;
    rar)
        unrar x "$1"
        ;;
    esac
    rm "$1"
}

#special commands that are not games
if [ -z "$1" ]; then
    case "$1" in
    update)
        romupdate
        ;;

    version)
        echo "veeery early beta"
        ;;
    help)
        curl https://raw.githubusercontent.com/paperbenni/CloudPie/master/help.txt
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

pushd ~/.config/cloudpie

if [ -e rom.conf ]; then
    ROMDIR=$(cat rom.conf)
else
    echo "no rom directory selected falling back to default"
    ROMDIR="$HOME/cloudpie/roms"
    mkdir -p ~/cloudpie/roms
    echo "$HOME/cloudpie/roms" >rom.conf
fi
popd

cd ~/cloudpie

echo "for what console would you like your game?"
PS3="Select platform: "
select console in $(cat platforms.txt); do
    pushd repos
    LINK=$(cat $console.txt | tail -1)

    game=$(cat "$console".txt | ~/cloudpie/path/fzf)
    echo "downloading $game"

    pushd "$ROMDIR"
    mkcd "$console"
    GAMENAME=${game%.*}

    if ls ./"$GAMENAME".* 1>/dev/null 2>&1; then
        echo "game $GAMENAME already exists"
    else
        wget "$LINK$game"
        unpack "$game"
    fi

    popd

    break
done
