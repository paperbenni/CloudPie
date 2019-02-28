#!/bin/bash
source ~/cloudpie/functions.sh

PS3="what platform does your game run on?"

pushd ~/cloudpie/roms
select PLATFORM in $(ls); do
    echo "$PLATFORM"
    pushd "$PLATFORM"
    GAME=$(ls | ~/cloudpie/path/fzf)
    if [ -z "$GAME" ]; then
        echo "operation canceled"
        exit 0
        break
    fi
    echo "starting $GAME"
    openrom "$HOME/cloudpie/roms/$PLATFORM/$GAME" "$PLATFORM"
    break
done
