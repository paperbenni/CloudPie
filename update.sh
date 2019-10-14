#!/bin/bash
#this updates various retroarch/libretro files

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie
pb mediafire

#check for internet
if curl cht.sh &>/dev/null; then
    echo "internet found"
else
    echo "no internet"
    exit 1
fi

cd

#controller autoconfig
retroupdate autoconfig "https://buildbot.libretro.com/assets/frontend/autoconfig.zip"
#ui assets
retroupdate assets "https://buildbot.libretro.com/assets/frontend/assets.zip"
#game databases for scanning
retroupdate database "https://buildbot.libretro.com/assets/frontend/database-rdb.zip"
# core info (what core for what format)
retroupdate info "https://buildbot.libretro.com/assets/frontend/info.zip"
# shaders
retroupdate shaders "https://buildbot.libretro.com/assets/frontend/shaders_glsl.zip"

#cores
rm -rf ~/retroarch/cores
mkdir -p ~/retroarch/cores
cd ~/retroarch/cores
echo "fetching cores"
for i in ~/cloudpie/consoles/*.conf; do
    core=$(grep 'core:' <$i | egrep -o '".*"' | egrep -o '[^"]*')
    echo "$core"
    wget -q --show-progress "https://buildbot.libretro.com/nightly/linux/x86_64/latest/${core}_libretro.so.zip"
    unzip "${core}_libretro.so.zip"
done

rm mupen64plus_libretro.so
mediafire http://www.mediafire.com/file/ffqxjfvuxz8w12s/mupen64plus_libretro.so

popd

mkdir -p ~/retroarch/bios
cd ~/retroarch/bios
wget "$(curl ps1.surge.sh)"
mv SCP* scph5501.bin

echo "done updating"
