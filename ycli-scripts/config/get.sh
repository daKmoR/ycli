#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

if [ -z "$1" ]; then
	echo "[ERROR] The first parameter needs to be a json path. Example get ycli.name";
	return 1;
fi

__ycliConfigPaths=("${ycliConfigPaths[@]}");

if [ -f "~/.yclirc.json" ]; then
	__ycliConfigPaths+=("~/.yclirc.json");
fi

pathConfigs=();
checkDir=$(pwd);
while [ "$checkDir" != "/" ]; do
	checkConfigPath="$checkDir/.yclirc.json";
	if [ -f "$checkConfigPath" ]; then
		pathConfigs=("$checkConfigPath" "${pathConfigs[@]}")
	fi
	checkDir=$(dirname "$checkDir");
done
__ycliConfigPaths+=(${pathConfigs[@]});

ycli util json get-merged "$1" --files "${__ycliConfigPaths[@]}"
