#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	ycliCommands="";
	_ycliAddCommandsFromPath "$YCLI_DIR/scripts/bower";
	_ycliAddCommandsFromPath "./scripts/bower";
	echo $ycliCommands;
	return;
fi
if [ "$3" == "ycliCommands" ]; then
	return;
fi

echo "Please use a subcommand";
