#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie

echo "starting CloudPie"
cloudconnect
sleep 1
retroarch
