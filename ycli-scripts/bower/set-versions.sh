#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

if [[ ! -f bower.json ]]; then
	echo "[ERROR] There is no bower.json in your current directory $(pwd)";
	return;
fi

if [[ ! -f "$1" && "$1" != "--help"  && "$2" != "--help" ]]; then
	echo "[ERROR] The File $1 does not exists";
	echo "[INFO] You have to provide a file where the wanted version are set e.g. set-version my-version.json"
	echo "Inside you have something like this";
	echo "{";
	echo "  \"paper-input\": \"2.0.0\"";
	echo "}";
	return 1;
fi

node $YCLI_DIR/ycli-scripts/bower/set-versions/set-versions.js $@
