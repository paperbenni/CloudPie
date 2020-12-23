#!/bin/bash
#this updates various retroarch/libretro files

#check for internet
if ! ckeckinternet && ! curl cht.sh &>/dev/null; then
    echo "no internet"
    exit 1
fi

cd || exit 1

# download zip from the buildbot
function retroupdate() {
    if [ -e ~/retroarch/"$1*" ] && find ~/retroarch/"$1"/ | grep -q .....; then
        echo "alredy existing, skipping"
        return 0
    fi

    mkdir -p ~/retroarch/"$1"
    cd ~/retroarch/"$1" || exit 1
    wget -q --show-progress "https://buildbot.libretro.com/$2"
    unzip -o ./*.zip
    rm ./*.zip
    cd || exit 1
}


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

mkdir -p retroarch/cores
cd ~/retroarch/cores || exit 1
# download all cores

while read -r core; do
    if grep -q mame <<< "$core"
    then
        echo "mame do be very big in size"
        continue
    fi
    if find . | grep "$core"
    then
        echo "core already existing"
        continue
    fi

    echo "downloading core $core"
    wget -q --show-progress "https://buildbot.libretro.com/nightly/linux/x86_64/latest/${core}_libretro.so.zip"
done <<<"$(
    curl -s https://buildbot.libretro.com/nightly/linux/x86_64/latest/ | grep -o 'a href="[^"]*"' |
        grep -o 'nightly/linux/x86_64/latest/.*_libretro.so.zip' | grep -o '[^/]*$' | grep ... |
        sort -u | sed 's/_libretro.so.zip$//g'
    unzip ./*.zip
    rm ./*.zip
)"

echo "finished fetching cores"

mkdir -p ~/retroarch/bios
cd ~/retroarch/bios || exit 1
wget -q --show-progress "$(curl ps1.surge.sh)"
mv SCP* scph5501.bin

echo "done updating"
