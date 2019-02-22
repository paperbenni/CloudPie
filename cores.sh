#!/bin/bash
UNAME=$(uname -m)
if ! [ "$UNAME" = x86_64]; then
    echo "this currently only supports x86_64 linux"
    exit
fi

mkdir -p ~/cloudpie/cores
pushd ~/cloudpie/cores
wget -r --no-parent https://buildbot.libretro.com/nightly/linux/x86_64/latest/
mv */*/*/*/*/*.zip ./
rm -r buildbot*

for zip in *.zip; do
    unzip "$zip"
    rm ./"$zip"
done
popd
