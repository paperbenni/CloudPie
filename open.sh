#!/usr/bin/env bash

################################################
## Opens a rom with cloudpie                  ##
################################################

if ! command -v cloudpie; then
    echo "installing cloudpie"
    xterm -e sh -c "curl -s https://raw.githubusercontent.com/paperbenni/CloudPie/master/setup.sh | bash"
fi

source <(curl -s https://raw.githubusercontent.com/paperbenni/bash/master/import.sh)
pb cloudpie
echo "opening standalone cloudpie game"
cloudconnect
openrom "$1"
