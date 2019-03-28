#!/bin/bash
#this updates various retroarch/libretro files

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie/cloudpie.sh
pb mediafire/mediafire.sh

#check if it's a pc
DEVICE=$(uname -m)
if ! [ "$DEVICE" = x86_64 ]; then
    echo "this currently only supports x86_64 linux"
    exit
fi

#check for internet
if curl cht.sh; then
    echo "internet found"
else
    echo "no internet"
    exit 1
fi

cd ~

#controller autoconfig
retroupdate autoconfig "https://buildbot.libretro.com/assets/frontend/autoconfig.zip"
#ui assets
retroupdate assets "https://buildbot.libretro.com/assets/frontend/assets.zip"
#game databases for scanning
retroupdate database "https://buildbot.libretro.com/assets/frontend/database-rdb.zip"

retroupdate info "https://buildbot.libretro.com/assets/frontend/info.zip"

retroupdate shaders "https://buildbot.libretro.com/assets/frontend/shaders_glsl.zip"

#cores
rm -rf ~/retroarch/cores
mkdir -p ~/retroarch/cores
pushd ~/retroarch/cores
wget -r --no-parent https://buildbot.libretro.com/nightly/linux/x86_64/latest/ -q --show-progress
mv */*/*/*/*/*.zip ./
rm -rf buildbot*
rm index.html

for zip in *.zip; do
    unzip -o "$zip"
    rm ./"$zip"
done

rm mupen64plus_libretro.so
mediafire http://www.mediafire.com/file/ffqxjfvuxz8w12s/mupen64plus_libretro.so

popd
echo "done updating"
