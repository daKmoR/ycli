#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

if [ -z $1 ]; then
	echo "[ERROR] You have to provide a branch e.g. ycli prepare development";
	return;
fi

_ycliRun multiple execute ycli git reset-to-branch-update $1
