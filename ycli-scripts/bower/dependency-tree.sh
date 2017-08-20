#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

if ! hash bower 2>/dev/null; then
	echo "[ERROR] bower not available pls install via npm install -g bower"
	return 1;
fi

node $YCLI_DIR/ycli-scripts/bower/dependency-tree/dependency-tree.js "$@"
