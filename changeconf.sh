#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie/cloudpie.sh

if ! retroarch --version; then
    echo "retroarch not installed"
    exit
fi
alias ccf="changeconf"
rm -rf ~/.config/retroarch
# change the retroarch directory configuration
ccf system_directory "~/retroarch/bios"
ccf savefile_directory "~/cloudpie/save"
ccf recording_output_directory "~/retrorecords"
ccf cheat_database_path "~/retroarch/cheats"
ccf libretro_directory "~/retroarch/cores"
ccf joypad_autoconfig_dir "~/retroarch/autoconfig"
cff content_database_path = "~/retroarch/database"
cff assets_directory "~/retroarch/assets/"
cff libretro_info_path "~/retroarch/info/"
cff video_shader_dir "~/retroarch/shaders"
cff content_database_path "~/retroarch/database"
# switch style menu
cff menu_driver "ozone"
cff automatically_add_content_to_playlist "true"
# turn off annoying hotkeys
cff input_exit_emulator "nul"
cff input_exit_emulator_axis "nul"
cff input_exit_emulator_btn "nul"
cff input_exit_emulator_mbtn "nul"
cff input_reset "nul"
cff input_rewind "nul"
cff input_movie_record_toggle "nul"
cff input_pause_toggle "nul"
cff input_desktop_menu_toggle "nul"
# wii style menu music
cff audio_enable_menu "true"
cff audio_enable_menu_bgm "true"
cff audio_enable_menu_cancel "true"
cff audio_enable_menu_notice "true"
cff audio_enable_menu_ok "true"
cff input_toggle_fast_forward "nul"
# fullscreen and sharp pixels
cff video_fullscreen "true"
cff video_smooth "false"
