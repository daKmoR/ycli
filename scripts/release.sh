#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	ycliCommands="";
	_ycliAddCommandsFromPath "$YCLI_DIR/scripts/release";
	_ycliAddCommandsFromPath "./scripts/release";
	echo $ycliCommands;
	return;
fi
if [ "$3" == "ycliCommands" ]; then
	return;
fi

echo "Please use a subcommand";
