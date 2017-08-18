#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	echo "error-only full raw";
	return;
fi

if [[ -z ${ycliWctResultFilePath} ]]; then
	ycliWctResultFilePath=$(ycli config get wct.resultFilePath);
fi

if [[ ! -f "$ycliWctResultFilePath" ]]; then
	echo "[ERROR] No saved result found - You should run a test with --save";
	echo "Example: $ycliName wct headless --save";
	return 1;
fi

if [[ -z "$1" || "$1" == "full" ]]; then
	grep -P ".*\(\d.*" ${ycliWctResultFilePath}
fi

if [[ "$1" == "error-only" ]]; then
	grep -P ".*\(\d*\/\d*\/[1-9][0-9]*" ${ycliWctResultFilePath}
fi

if [[ "$1" == "raw" ]]; then
	cat ${ycliWctResultFilePath}
fi

