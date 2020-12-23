#!/usr/bin/env bash

#################################################################
## Autoconfigure retroarch settings                            ##
#################################################################

if ! retroarch --version; then
    echo "retroarch not installed"
    exit
fi

function changeconf() {
    if ! [ -e ~/.config/retroarch/retroarch.cfg ]; then
        notify-send "generating config, please do not do anything with this retroarch instance"
        timeout 5 retroarch
    fi
    NEWVALUE="$1 = \"$2\""
    sed -i "/^$1 =/c $NEWVALUE" "$HOME"/.config/retroarch/retroarch.cfg
}

# change the retroarch directory configuration
changeconf system_directory "$HOME/retroarch/bios"
changeconf savefile_directory "$HOME/cloudpie/save"
changeconf recording_output_directory "$HOME/retrorecords"
changeconf cheat_database_path "$HOME/retroarch/cheats"
changeconf libretro_directory "$HOME/retroarch/cores"
changeconf joypad_autoconfig_dir "$HOME/retroarch/autoconfig"
changeconf content_database_path = "$HOME/retroarch/database"
changeconf assets_directory "$HOME/retroarch/assets/"
changeconf libretro_info_path "$HOME/retroarch/info/"
changeconf video_shader_dir "$HOME/retroarch/shaders"
changeconf content_database_path "$HOME/retroarch/database"

# switch style menu
changeconf menu_driver "xmb"

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
