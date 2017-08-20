#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

if [[ ! -z "${ycliMultipleElements[@]}" ]]; then
	echo "[INFO] The following components will be effected";
	for componentRoot in ${ycliMultipleElements[@]}; do
		echo "- $componentRoot";
	done

else
	echo "[INFO] The list of effected components is empty.";

fi
