#!/bin/bash

function _ycliStartTime {
	if date --version >/dev/null 2>&1 ; then
		_ycliStartTimeValue=$(date +%s%N)
	else
		_ycliStartTimeValue=$(date +%s)
	fi
}

function _ycliEndTime {
	if date --version >/dev/null 2>&1 ; then
		_ycliEndTimeValue=$(date +%s%N)
	else
		_ycliEndTimeValue=$(date +%s)
	fi
	_ycliDuration=$(expr $_ycliEndTimeValue - $_ycliStartTimeValue)
	_ycliDuration=$(awk "BEGIN {print $_ycliDuration/1000000000}")
}

#
# Colors only for interactive shells
#
# Example:
#   echo "The input has been ${cGreen}successfully${cReset} updated"
cRed=""
cGreen=""
cYellow=""
cBlue=""
cReset=""
if [[ $- == *i* ]]; then
	cRed=$(tput setaf 1)
	cGreen=$(tput setaf 2)
	cYellow=$(tput setaf 3)
	cBlue=$(tput setaf 4)
	cReset=$(tput sgr0)
fi


ycliPluginsPaths=();
ycliPluginsPaths+=(".");

ycliPluginsCollectionsDirs=();
ycliPluginsCollectionsDirs+=($(npm root -g));
ycliPluginsCollectionsDirs+=($(dirname $YCLI_DIR));
for ycliPluginsCollectionsDir in ${ycliPluginsCollectionsDirs[@]}; do
	for possiblePluginDir in ${ycliPluginsCollectionsDir}/*; do
		if [[ -d ${possiblePluginDir} && $(basename ${possiblePluginDir}) == "ycli-"* ]]; then
			ycliPluginsPaths+=("$possiblePluginDir");
		fi
	done
done

ycliPluginsPaths+=("$YCLI_DIR");

function _ycliAddCommandsForPath {
	for pluginPath in ${ycliPluginsPaths[@]}; do
		scriptDirPath="$pluginPath/scripts/$1";
		if [ -d ${scriptDirPath} ]; then

			for filePath in ${scriptDirPath}/{*.sh,*.js}; do
				if [ -f $filePath ]; then
					fileName=${filePath/$scriptDirPath\//}
					ycliCommand=${fileName%.*};
				fi
				if [[ ! $ycliCommands == *"$ycliCommand "* ]]; then
					ycliCommands="$ycliCommands $ycliCommand ";
				fi
			done

		fi
	done
}

function _ycliRun {
	length=$(($#))
	params=$@
	scriptParamsPath=${params// /\/};
	while [ ! -z ${scriptParamsPath} ]; do

		for pluginPath in ${ycliPluginsPaths[@]}; do
			scriptPath="$pluginPath/scripts/$scriptParamsPath.sh";
			if [ -f ${scriptPath} ]; then
				shift ${length};
				source ${scriptPath};
				return;
			fi
			nodeScriptPath="$pluginPath/scripts/$scriptParamsPath.js";
			if [ -f ${nodeScriptPath} ]; then
				shift ${length};
				node ${nodeScriptPath} "$@";
				return;
			fi
		done

		length=$((length-1));
		params=${@:1:${length}}
		scriptParamsPath=${params// /\/}
	done

	echo "[ERROR] Command $scriptParamsPath not found";
	return;
}

function ycli() {
	if [ "$(ps -p "$$" -o comm=)" != "bash" ]; then
		bash -c "\. \"$YCLI_DIR/ycli.sh\" && \. \"$YCLI_DIR/bash_completion.sh\" && ycli $(printf "'%s' " "$@")"
	else
		ycliCommands="";
		_ycliAddCommandsForPath ".";

		if [[ -z "$1" || "$1" == "--help" ]]; then
			_ycliRun help

		else
			if [ "$1" == "ycliCommands" ]; then
				echo "$ycliCommands";

			else
				_ycliRun "$@"
			fi
		fi
	fi
}
