#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

currentDir=$(pwd);
versionFiles=("${currentDir}/package.json" "${currentDir}/bower.json");

currentVersion=$(ycli util json get-merged version --files ${versionFiles[@]});
if [[ ! -z "$currentVersion" ]]; then
	echo "$currentVersion";
	return 0;
else
	echo "[ERROR] No current version found - I checked here ${versionFiles[@]}";
	return 1;
fi
