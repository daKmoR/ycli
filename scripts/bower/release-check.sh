#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

currentDir=$(pwd);
packageName=$(ycli util json ${currentDir}/package.json get name);
currentVersion=$(ycli util json ${currentDir}/package.json get version);
bowerVersion=$(bower info "$packageName" --verbose | grep -A1 'Available versions:' | tail -n 1 | sed -r 's/^.{4}//');

if [[ "$currentVersion" == "$bowerVersion" ]]; then
	echo "✓ Bower has the same latest version $currentVersion";
else
	echo "✗ Not available with Bower";
	echo "Version in package.json: $currentVersion";
	echo "Version on Bower:  $bowerVersion";
fi
