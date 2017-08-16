#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

currentDir=$(pwd);
versionFiles=("${currentDir}/package.json" "${currentDir}/bower.json");

currentVersion="";
for versionFile in "${versionFiles[@]}"; do
	if [[ -f ${versionFile} ]]; then
		currentVersion=$(ycli util json ${versionFile} get version);
		echo "$currentVersion";
		return 0;
	fi
done
if [[ -z "$currentVersion" ]]; then
	echo "[ERROR] No current version found - I checked here ${versionFiles[@]}";
	return 1;
fi
