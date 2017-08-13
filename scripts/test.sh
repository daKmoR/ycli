#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	ycliCommands="";
	_ycliAddCommandsFromPath "$YCLI_DIR/scripts/test";
	_ycliAddCommandsFromPath "./scripts/test";
	echo $ycliCommands;
	return;
fi
if [ "$3" == "ycliCommands" ]; then
	return;
fi

echo "Please use a subcommand";
