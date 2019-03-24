#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie/cloudpie.sh

if ! retroarch --version; then
    echo "retroarch not installed"
    exit
fi
rm -rf ~/.config/retroarch
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
changeconf automatically_add_content_to_playlist "true"
changeconf content_database_path "~/retroarch/database"
changeconf input_exit_emulator "nul"
changeconf input_exit_emulator_axis "nul"
changeconf input_exit_emulator_btn "nul"
changeconf input_exit_emulator_mbtn "nul"
changeconf video_fullscreen "true"
changeconf audio_enable "true"
changeconf audio_enable_menu "true"
changeconf audio_enable_menu_bgm "true"
changeconf audio_enable_menu_cancel "true"
changeconf audio_enable_menu_notice "true"
changeconf audio_enable_menu_ok "true"
