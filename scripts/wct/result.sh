#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	echo "error-only full raw";
	return;
fi

optionResultFilePath=".tmp/_lastBrowserStackTestResult.txt";
optionMode="error-only";


if [[ -z "$1" || "$1" == "full" ]]; then
	grep -P ".*\(\d.*" $optionResultFilePath
fi

if [[ "$1" == "error-only" ]]; then
	grep -P ".*\(\d*\/\d*\/[1-9][0-9]*" $optionResultFilePath
fi

if [[ "$1" == "raw" ]]; then
	cat $optionResultFilePath
fi
