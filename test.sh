#!/usr/bin/env bash

#############################################
## install a local version for development ##
#############################################

cd ~/workspace/CloudPie
cp *.sh ~/cloudpie/
chmod +x ~/cloudpie/*.sh
cp formats.txt ~/cloudpie/
cp -r consoles ~/cloudpie/
# cp -r config/* ~/.config/retroarch/
