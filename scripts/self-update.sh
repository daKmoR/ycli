#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

currentDir=$(pwd);
cd "$YCLI_DIR"
git pull
npm install
source "$YCLI_DIR/ycli.sh"
cd "$currentDir"

echo "ycli has been ${cGreen}successfully${cReset} updated"
