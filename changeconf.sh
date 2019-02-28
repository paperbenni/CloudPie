#!/usr/bin/env bash

source ~/cloudpie/functions.sh

if ! ~/cloudpie/path/retroarch; then
    echo "retroarch not installed"
    exit
fi

# change the retroarch directory configuration
changeconf system_directory "~/retroarch/bios"
changeconf savefile_directory "~/cloudpie/save"
changeconf recording_output_directory "~/retrorecords"
changeconf cheat_database_path "~/retroarch/cheats"
changeconf libretro_directory "~/retroarch/cores"
changeconf joypad_autoconfig_dir "~/retroarch/autoconfig"
changeconf content_database_path = "~/retroarch/database"
changeconf menu_driver "ozone"
changeconf assets_directory "~/retroarch/assets/"
changeconf libretro_info_path "~/retroarch/info/"
changeconf video_shader_dir "~/retroarch/shaders"
