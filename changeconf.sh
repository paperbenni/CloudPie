#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie/cloudpie.sh

if ! retroarch --version; then
    echo "retroarch not installed"
    exit
fi
rm -rf ~/.config/retroarch

ccf() {
    changeconf "$@f"
}

# change the retroarch directory configuration
ccf system_directory "~/retroarch/bios"
ccf savefile_directory "~/cloudpie/save"
ccf recording_output_directory "~/retrorecords"
ccf cheat_database_path "~/retroarch/cheats"
ccf libretro_directory "~/retroarch/cores"
ccf joypad_autoconfig_dir "~/retroarch/autoconfig"
ccf content_database_path = "~/retroarch/database"
ccf assets_directory "~/retroarch/assets/"
ccf libretro_info_path "~/retroarch/info/"
ccf video_shader_dir "~/retroarch/shaders"
ccf content_database_path "~/retroarch/database"
# switch style menu
ccf menu_driver "rgui"
ccf rgui_menu_color_theme "17"

ccf automatically_add_content_to_playlist "true"
# turn off annoying hotkeys
ccf input_exit_emulator "nul"
ccf input_exit_emulator_axis "nul"
ccf input_exit_emulator_btn "nul"
ccf input_exit_emulator_mbtn "nul"
ccf input_reset "nul"
ccf input_rewind "nul"
ccf input_movie_record_toggle "nul"
ccf input_pause_toggle "nul"
ccf input_desktop_menu_toggle "nul"
# wii style menu music
ccf audio_enable_menu "true"
ccf audio_enable_menu_bgm "true"
ccf audio_enable_menu_cancel "true"
ccf audio_enable_menu_notice "true"
ccf audio_enable_menu_ok "true"
ccf input_toggle_fast_forward "nul"
# fullscreen and sharp pixels
ccf video_fullscreen "true"
ccf video_smooth "false"
ccf menu_linear_filter "false"
ccf custom_viewport_height "1080"
ccf custom_viewport_width "1920"
