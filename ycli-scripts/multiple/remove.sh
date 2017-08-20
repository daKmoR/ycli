#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	echo *
	return;
fi

if [ -z "$1" ]; then
	echo "[ERROR] You have to provide a filter";
	return;
fi

myDir=$(pwd);
allDirs=();
for arg do
	newDir=$(readlink -f  ${myDir}/${arg})
	allDirs+=("$newDir");
done

for componentRoot in ${allDirs[@]}; do
	if [[ ! -d ${componentRoot} ]]; then
		echo "[ERROR] Your filter should only return directories - current value $componentRoot"
		echo "[INFO]  You sure you are in the parent directory of all your components?"
		return;
	fi

	ycliMultipleElements=("${ycliMultipleElements[@]/$componentRoot}");
done

ycli multiple list
