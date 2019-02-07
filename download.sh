#!/bin/bash

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
    mkdir -p ~/cloudpie/repos
    pushd ~/cloudpie/repos

    repoload 'Nintendo%2064/Roms' n64 "Nintendo 64" z64
    repoload 'SNES' snes "Super Nintendo Entertainment System" zip
    repoload 'Playstation/Games/NTSC' psx "Play Station 1" zip
    repoload 'Nintendo Gameboy Advance' gba "Game Boy Advance" zip
    repoload 'Nintendo%20DS' ds "Nintendo DS" 7z

    popd
}

if [ "$1" = update ]; then
    romupdate
    exit
else
    if [ -z "$1" ]; then
        which game would you like to have?
        read ROMGAME
    else
        ROMGAME="$1"
        echo "installing $1"
    fi
fi

if ! dialog --version; then
    echo "dialog must be installed in order for this to work"
    exit
fi

pushd ~/.config/cloudpie

if [ -e rom.conf ]; then
    ROMDIR=$(cat rom.conf)
else
    ROMDIR="$HOME/cloudpie/roms"
    mkdir -p ~/cloudpie/roms
fi
popd

cd ~/cloudpie

echo "for what console would you like your game?"
PS3="Select platform: "
select console in $(cat platforms.txt); do
    pushd repos
    LINK=$(cat $console.txt | tail -1)

    cat "$console".txt | head -n -1 | agrep -i -2 "$ROMGAME" | head -20 >cache.txt

    IFS2="$IFS"
    IFS=$'\n'
    PS3="Choose from results: "
    select game in $(cat cache.txt); do
        echo "downloading $game"

        pushd "$ROMDIR"
        mkcd "$console"
        GAMENAME=${game%.zip}

        if ls ./"$GAMENAME".* 1>/dev/null 2>&1; then
            echo "game $GAMENAME already exists"
        else
            wget "$LINK$game"
            if [ "$game" == *".zip" ]; then
                echo "unpacking game"
                unzip ./"$game"
                rm $game
            fi
            
            if [ "$game" == *".7z" ]; then
                echo "unpacking game"
                7za x ./"$game"
                rm $game
            fi
        fi

        popd
        rm cache.txt
        break
    done
    break
    IFS="$IFS2"
done
