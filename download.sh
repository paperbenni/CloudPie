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
    clear
    echo "N64 selected
    what game would you like to have?"
    read n64rom
    romsearch "~/cloudpie/repos/n64.txt" "$n64rom"
    cd $ROMDIR
    CURRENTROM=$(cat ~/cloudpie/cache.txt)
    wget https://the-eye.eu/public/rom/Nintendo%2064/Roms/"$CURRENTROM"
    rm ~/cloudpie/cache.txt
    ;;
3)
    clear
    echo "SNES selected"

    ;;
*)
    echo "system not supported"
    ;;
esac


function romsearch() {
    cat "$1" | agrep -2 -i "$2" >romsearch.txt

    HEIGHT=15
    WIDTH=50
    CHOICE_HEIGHT=4
    BACKTITLE="ROM selection"
    TITLE="ROMS"
    MENU="Select rom:"

    OPTIONS=(1 "awk '{if(NR==1) print $0}' romsearch.txt"
        2 "awk '{if(NR==2) print $0}' romsearch.txt"
        3 "awk '{if(NR==3) print $0}' romsearch.txt")

    CHOICE=$(dialog --clear \
        --backtitle "$BACKTITLE" \
        --title "$TITLE" \
        --menu "$MENU" \
        $HEIGHT $WIDTH $CHOICE_HEIGHT \
        "${OPTIONS[@]}" \
        2>&1 >/dev/tty)
    rm romsearch.txt
    clear
    echo $CHOICE >~/cloudpie/cache.txt
}
