#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	ycliCommands="";
	_ycliAddCommandsFromPath "$YCLI_DIR/scripts/util";
	_ycliAddCommandsFromPath "./scripts/util";
	echo $ycliCommands;
	return;
fi
if [ "$2" == "ycliCommands" ]; then
	return;
fi
