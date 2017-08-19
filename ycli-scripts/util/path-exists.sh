#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	echo *
	return;
fi

if [ -d "$1" ]; then
	echo "✓ Folder $1 exists";
	return;
fi

if [ -f "$1" ]; then
	echo "✓ File $1 exists";
	return;
fi
