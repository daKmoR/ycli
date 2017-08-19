#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	ycliCommands=();
	_ycliAddCommandsForPath "wct";
	echo "${ycliCommands[@]}";
	return;
fi
if [ "$3" == "ycliCommands" ]; then
	return;
fi

echo "Please use a subcommand";
