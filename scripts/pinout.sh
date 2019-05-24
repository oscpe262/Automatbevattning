#!/bin/bash
source /root/pinbase.sh
# Activate a pin
# syntax: pinout.sh <pin#> <{0,1}>
exportPin $1
setOutput $1
echo $2 > $BASE_GPIO_PATH/gpio$1/value
