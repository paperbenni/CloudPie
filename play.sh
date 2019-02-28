#!/bin/bash
function retro() {
    ~/cloudpie/path/retroarch -L "~/retroarch/cores/$1.so" "$2"
}

function openrom() {
    if ! [ -e "$1" ]; then
        echo "game not found"
        exit 1
    fi
    case "$2" in
    n64)
        retro "parallel_n64_libretro" "$1"
        ;;
    ds)
        retro "desmume2015_libretro" "$1"
        ;;
    snes)
        retro "snes9x_libretro" "$1"
        ;;
    psx)
        retro "mednafen_psx_libretro" "$1"
        ;;
    *)
        echo "no core found for $2"
        ;;
    esac

}

PS3="what platform does your game run on?"

pushd ~/cloudpie/roms
select PLATFORM in $(ls); do
    echo "$PLATFORM"
    pushd "$PLATFORM"
    GAME=$(ls | ~/cloudpie/path/fzf)
    if [ -z "$GAME" ]; then
        echo "operation canceled"
        exit 0
    fi
    echo "starting $GAME"
    openrom "~/cloudpie/roms/$PLATFORM/$GAME" "$PLATFORM"
done
