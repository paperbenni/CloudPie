#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie
pb file
cloudconnect
cd
waitforfile "~/cloudpie/save/cloud.txt"
cd cloudpie/save

if [ -e "wii.txt" ]; then
    echo "wii already exists, exiting dolphin wizard"
    exit 1
fi

echo "processing GameCube"
if filecheck "~/.local/share/dolphin-emu/GC" "no dolphin gcn saves found"; then
    echo "making backup"
    cp -r "~/.local/share/dolphin-emu/GC" "~/.local/share/dolphin-emu/GC2"
    echo "uploading saves"
    mv "~/.local/share/dolphin-emu/GC" .
fi
ln -s "~/cloudpie/save/GC" "~/.local/share/dolphin-emu/GC"

echo "processing Wii"
if filecheck "~/.local/share/dolphin-emu/Wii" "no dolphin wii saves found"; then
    echo "making backup"
    cp -r "~/.local/share/dolphin-emu/Wii" "~/.local/share/dolphin-emu/Wii2"
    echo "uploading saves"
    mv "~/.local/share/dolphin-emu/Wii" .
fi
ln -s "~/cloudpie/save/Wii" "~/.local/share/dolphin-emu/Wii"
