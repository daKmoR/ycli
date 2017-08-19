#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	ycliCommands=();
	_ycliAddCommandsForPath "util";
	echo "${ycliCommands[@]}";
	return;
fi
if [ "$2" == "ycliCommands" ]; then
	return;
fi
