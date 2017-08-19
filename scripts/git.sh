#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	ycliCommands=();
	_ycliAddCommandsForPath "git";
	echo "${ycliCommands[@]}";
	return;
fi
if [ "$2" == "ycliCommands" ]; then
	return;
fi

echo "Please use a git subcommand";
