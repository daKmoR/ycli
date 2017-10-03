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

echo "[START] Searching for dependencies...";
htmlFiles="*.html";
allFound=();
for htmlFile in ${htmlFiles}; do
	for inFileFound in $(cat ${htmlFile} | grep -o -e "rel=\"import\" href=\"\.\.\/.*/" | sed 's/.*\.\.//' | cut -d / -f 2); do
		if [[ ! " ${allFound[@]} " =~ " ${inFileFound} " ]]; then
			allFound+=(${inFileFound});
		fi
	done
done
for found in ${allFound[@]}; do
	version=$(ycli bower get-latest-version-for "$found");
	ycli util json set dependencies.${found} ${version} --file ${currentDir}/bower.json
done


echo "[START] Searching for devDependencies...";
htmlFiles=$(find test/ demo/ -iname "*.html" -type f)
allFound=();
for htmlFile in ${htmlFiles}; do
	for inFileFound in $(cat ${htmlFile} | grep -o -e "rel=\"import\" href=\"\.\.\/.*/" | sed 's/.*\.\.//' | cut -d / -f 2); do
		if [[ ! " ${allFound[@]} " =~ " ${inFileFound} " ]]; then
			allFound+=(${inFileFound});
		fi
	done
done
for found in ${allFound[@]}; do
	version=$(ycli bower get-latest-version-for "$found");
	echo $(ycli util json get dependencies.${found} --file ${currentDir}/bower.json);
	if [[ $(ycli util json get dependencies.${found} --file ${currentDir}/bower.json) == "" ]]; then
		ycli util json set devDependencies.${found} ${version} --file ${currentDir}/bower.json
	fi
done
