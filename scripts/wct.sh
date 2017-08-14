#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	ycliCommands="";
	_ycliAddCommandsForPath "wct";
	echo $ycliCommands;
	return;
fi
if [ "$3" == "ycliCommands" ]; then
	return;
fi

#echo "Please use a subcommand";

ycliPluginsCollectionsDirs=();
ycliPluginsCollectionsDirs+=($(npm root -g));
ycliPluginsCollectionsDirs+=($(dirname $YCLI_DIR));
for ycliPluginsCollectionsDir in ${ycliPluginsCollectionsDirs[@]}; do
	for possiblePluginDir in ${ycliPluginsCollectionsDir}/*; do
		if [[ -d ${possiblePluginDir} && $(basename ${possiblePluginDir}) == "ycli-"* ]]; then
			echo $possiblePluginDir;
		fi
	done
done
