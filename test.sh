#!/usr/bin/env bash

cd ~/workspace/CloudPie
cp *.sh ~/cloudpie/
chmod +x ~/cloudpie/*.sh
chmod +x bin/*
sudo cp bin/* /bin
cp formats.txt ~/cloudpie/
