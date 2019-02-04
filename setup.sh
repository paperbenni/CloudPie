#!/bin/bash

echo "installing cloudpie"
sudo apt-get update
sudo apt install -y dialog curl agrep
pushd ~/
mkdir cloudpie
cd cloudpie
