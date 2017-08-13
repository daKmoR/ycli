#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	echo *
	return;
fi

if [ "$2" == "ycliCommands" ]; then
	echo "get get-keys delete set";
	return;
fi

if [ ! -f "$1" ]; then
	echo "[ERROR] Your first parameter needs to be a valid file";
	return;
fi

node $YCLI_DIR/scripts/util/json/json.js "$@"
