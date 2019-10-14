#!/bin/bash

#######################################################
## start standalone retroarch with cloudpie enabled  ##
#######################################################

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie

echo "starting CloudPie"
# mount mega drive
cloudconnect
sleep 1
retroarch
