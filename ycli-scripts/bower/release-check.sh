#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

if [[ ! -f bower.json ]]; then
	echo "[ERROR] There is no bower.json in your current directory $(pwd)";
	return 1;
fi

currentDir=$(pwd);
packageName=$(ycli util json get name --file ${currentDir}/bower.json);
currentVersion=$(ycli util json get version --file ${currentDir}/bower.json);
bowerVersion=$(bower info "$packageName" --verbose | grep -A1 'Available versions:' | tail -n 1 | sed -r 's/^.{4}//');

if [[ "$currentVersion" == "$bowerVersion" ]]; then
	echo "✓ Bower has the same latest version $currentVersion";
else
	echo "✗ Not available with Bower";
	echo "Version in package.json: $currentVersion";
	echo "Version on Bower:  $bowerVersion";
fi
