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
changeconf assets_directory "~/retroarch/assets/"
changeconf libretro_info_path "~/retroarch/info/"
changeconf video_shader_dir "~/retroarch/shaders"
changeconf content_database_path "~/retroarch/database"
# switch style menu
changeconf menu_driver "rgui"
changeconf rgui_menu_color_theme "17"
changeconf rgui_menu_user_language "0"

changeconf automatically_add_content_to_playlist "true"
# turn off annoying hotkeys
changeconf input_exit_emulator "nul"
changeconf input_exit_emulator_axis "nul"
changeconf input_exit_emulator_btn "nul"
changeconf input_exit_emulator_mbtn "nul"
changeconf input_reset "nul"
changeconf input_rewind "nul"
changeconf input_movie_record_toggle "nul"
changeconf input_pause_toggle "nul"
changeconf input_desktop_menu_toggle "nul"
# wii style menu music
changeconf audio_enable_menu "true"
changeconf audio_enable_menu_bgm "true"
changeconf audio_enable_menu_cancel "true"
changeconf audio_enable_menu_notice "true"
changeconf audio_enable_menu_ok "true"
changeconf input_toggle_fast_forward "nul"
# fullscreen and sharp pixels
changeconf video_fullscreen "true"
changeconf video_smooth "false"
changeconf menu_linear_filter "false"
changeconf custom_viewport_height "1080"
changeconf custom_viewport_width "1920"
