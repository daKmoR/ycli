#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

if [ -z $1 ]; then
	echo "[ERROR] You have to provide a branch e.g. $ycliName prepare development";
	return;
fi

_ycliRun multiple execute $ycliName git reset-to-branch-update $1