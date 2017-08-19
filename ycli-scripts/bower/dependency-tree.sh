#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

node $YCLI_DIR/ycli-scripts/bower/dependency-tree/dependency-tree.js "$@"
