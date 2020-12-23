#!/bin/bash

############################################
## remove cloudpie but keep roms          ##
############################################

cd || exit 1

echo "Removing cloudpie"

# don't delete any roms
mv cloudpie/roms ~/

rm -rf cloudpie
rm -rf ~/.cache/retroarch
mv ~/retroarch ~/.cache/retroarch
rm -rf .config/retroarch

cd /usr/bin/
sudo unlink cloudrom
sudo unlink cloudpie
sudo unlink cloudarch
sudo rm cloudrom &> /dev/null
sudo rm cloudpie &> /dev/null
sudo rm cloudarch &> /dev/null
