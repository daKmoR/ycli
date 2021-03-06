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
bowerVersion=$(ycli bower get-latest-version-for "$packageName" --verbose);

if [[ "$currentVersion" == "$bowerVersion" ]]; then
	echo "✓ Bower Repository has the same latest version $currentVersion";
else
	echo "✗ Bower Repository has a different latest version";
	echo "Version in package.json: $currentVersion";
	echo "Version on Bower Repository: $bowerVersion";
fi
