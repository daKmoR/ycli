#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

currentDir=$(pwd);
cd "$YCLI_DIR"

if [ -d .git ]; then
	git pull
	npm install
	source "$YCLI_DIR/ycli.sh"
else
	npm install -g "$ycliName"
fi

cd "$currentDir"

echo "$ycliName has been ${cGreen}successfully${cReset} updated"
