#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	ycliCommands="";
	_ycliAddCommandsFromPath "$YCLI_DIR/scripts/git";
	_ycliAddCommandsFromPath "./scripts/git";
	echo $ycliCommands;
	return;
fi
if [ "$2" == "ycliCommands" ]; then
	return;
fi

echo "Please use a git subcommand";
