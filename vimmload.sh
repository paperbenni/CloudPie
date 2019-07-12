#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)

pb cloudpie/vimm
pb bash

cd
mkdir vimm
cd vimm
CONSOLE=$(cat vimm.txt | egrep -o '.*:' | egrep -o '[^:]*' | dmenu -l 10)
zerocheck "$CONSOLE"
echo "$CONSOLE"

test -e "$CONSOLE.txt" || curlvimm "$CONSOLE"
GAME=$(cat $CONSOLE.txt | dmenu -l 30)

GAMEID=$(cat "$CONSOLE"2.txt | grep ">$GAME<" | egrep -o 'rating&amp;id=[0-9]{4,}">' | egrep -o '[0-9]{4,}')
CONSOLE2=$(cat ~/vimm/vimm.txt | egrep "^$CONSOLE" | egrep -o ':.*' | egrep -o '[^:]*')
echo "destination $CONSOLE2"
mkdir -p ~/cloudpie/roms/"$CONSOLE2"
cd ~/cloudpie/roms/"$CONSOLE2"
echo "$GAMEID"
vimm "$GAMEID"
