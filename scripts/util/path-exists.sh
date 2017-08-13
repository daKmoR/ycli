#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	echo *
	return;
fi

if [ -d "$1" ]; then
	echo "[INFO] Folder $1 exists";
	return;
fi

if [ -f "$1" ]; then
	echo "[INFO] File $1 exists";
	return;
fi
