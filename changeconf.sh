#!/usr/bin/env bash

if ! ~/cloudpie/path/retroarch; then
    echo "retroarch not installed"
    exit
fi

function changeconf() {
    if [ -z "$2" ]; then
        echo "usage: changeconf option value"
    fi
    if [ -z "$3" ]; then
        if ! [ -e ~/.config/retroarch/retroarch.cfg ]; then
            echo "generating config"
            timeout 5 ~/cloudpie/path/retroarch
        fi
        pushd ~/.config/retroarch
        NEWVALUE="$1 = \"$2\""
        sed -i "/$1/c $NEWVALUE" retroarch.cfg
        popd
    fi

}

# change the retroarch directory configuration
changeconf system_directory '~/retroarch/bios'
changeconf savefile_directory '~/cloudpie/save'
changeconf recording_output_directory '~/retrorecords'
changeconf cheat_database_path '~/retroarch/cheats'
changeconf libretro_directory '~/retroarch/cores'
changeconf joypad_autoconfig_dir '~/retroarch/autoconfig'
changeconf content_database_path = '~/retroarch/database'
changeconf menu_driver 'ozone'
changeconf assets_directory '~/retroarch/assets/'
changeconf libretro_info_path '~/retroarch/info/'
