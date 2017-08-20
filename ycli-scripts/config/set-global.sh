#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

if [ -z "$1" ]; then
	echo "[ERROR] The first parameter needs to be a json path. Example set ycli.name newValue";
	return 1;
fi

if [ -z "$2" ]; then
	echo "[ERROR] The second parameter needs to be a string value. Example set ycli.name newValue";
	return 1;
fi

ycli util json set "$1" "$2" --file "~/.yclirc.json"
