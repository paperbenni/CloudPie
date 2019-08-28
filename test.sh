#!/usr/bin/env bash

cd ~/workspace/CloudPie
cp *.sh ~/cloudpie/
chmod +x ~/cloudpie/*.sh
cp formats.txt ~/cloudpie/
cp -r consoles ~/cloudpie/
mv config/* ~/.config/retroarch/
