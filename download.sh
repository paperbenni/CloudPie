#!/bin/bash

if ! dialog --version; then
    echo "dialog must be installed in order for this to work"
    exit
fi

cd ~/cloudpie

echo "please select system
1)Update repos (Do this on first run)
2)N64
3)SNES
4)NES"
read gameconsole
clear
case "$gameconsole" in
1)
    mkdir repos
    cd repos
    select repoconsole in $(cat platforms.txt); do
        case "$repoconsole" in
        "N64")
            echo "updating Nintendo 64 repos"
            curl https://the-eye.eu/public/rom/Nintendo%2064/Roms/ >n64.tmp
            cat n64.tmp | sed -e 's/.*>\(.*\)<\/a>.*/\1/' >n64.tmp2
            cat n64.tmp2 | grep '.z64' >n64.txt
            rm n64.tmp2
            rm n64.tmp
            ;;
        "SNES")
            echo "updating Super Nintendo Entertainment System repos"
            curl https://the-eye.eu/public/rom/SNES/ >snes.tmp
            cat snes.tmp | sed -e 's/.*>\(.*\)<\/a>.*/\1/' >snes.tmp2
            cat snes.tmp2 | grep '.zip' >snes.txt
            rm snes.tmp2
            rm snes.tmp
            ;;
        "PSX")
            echo "updating Playstation 1 repos"
            curl https://the-eye.eu/public/rom/Playstation/Games/NTSC/ >psx.tmp
            cat psx.tmp | sed -e 's/.*>\(.*\)<\/a>.*/\1/' >psx.tmp2
            cat psx.tmp2 | grep '.zip' >psx.txt
            rm psx.tmp2
            rm psx.tmp
            ;;
        esac
    done
    ;;
2)
    echo "N64 selected"
    select ROMGAME in $(cat repos/n64.txt); do
        echo "lel"
    done

    ;;
3)
    echo "system not supported"
    ;;
esac
