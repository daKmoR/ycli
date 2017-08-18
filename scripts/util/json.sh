#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	echo "get get-merged get-keys get-keys-merged delete set";
	return;
fi

if [ "$2" == "ycliCommands" ]; then
	return;
fi

node $YCLI_DIR/scripts/util/json/json.js "$@"
