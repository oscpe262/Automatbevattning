#!/bin/bash
# vim:ts=2:sw=2:sts=2:
# Common path for all GPIO access
BASE_GPIO_PATH=/sys/class/gpio

# Assign names to states
#ON="1"
#OFF="0"

# Utility function to export a pin if not already exported
exportPin() {
	if [ ! -e $BASE_GPIO_PATH/gpio$1 ]; then
		echo "$1" > $BASE_GPIO_PATH/export
	fi
}

# Utility function to set a pin as an output
setOutput() {
	echo "out" > $BASE_GPIO_PATH/gpio$1/direction
}

setInput() {
	echo "in" > $BASE_GPIO_PATH/gpio$1/direction
}

