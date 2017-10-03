#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

filesToUseOn=$(find . -iname "*.html" -type f -not -path "./bower_components*" -not -path "./node_modules/*")

currentDir=$(pwd);

dependencies=$(ycli util json get-keys dependencies --file ${currentDir}/bower.json)
for dependency in $dependencies; do

	found=0;
	for fileToProcess in $filesToUseOn; do
		if grep -q -e "$dependency/" -e "$dependency\\\\/" $fileToProcess; then
			found=1;
		fi
	done

	if [[ $found == 0 ]]; then
		ycli-raw util json delete "dependencies.$dependency" --file ${currentDir}/bower.json
	fi

done


devDependencies=$(ycli util json get-keys devDependencies --file ${currentDir}/bower.json)
for dependency in $devDependencies; do

	found=0;
	for fileToProcess in $filesToUseOn; do
		if grep -q -e "$dependency/" -e "$dependency\\\\/" $fileToProcess; then
			found=1;
		fi
	done

	if [[ $found == 0 ]]; then
		ycli-raw util json delete "devDependencies.$dependency" --file ${currentDir}/bower.json
	fi

done
