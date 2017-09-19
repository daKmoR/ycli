#!/bin/bash

ycliSubCli=0;
ycliConfigPaths=("$YCLI_DIR/.yclirc.json");
ycliCliPaths=("$YCLI_DIR/ycli.sh");

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

function _ycliFindPlugins {
	ycliPluginPattern="ycli-";
	if [ ! -z "$1" ]; then
		ycliPluginPattern="$1";
	fi

	ycliFoundPluginsPaths=();
	ycliFoundPluginsPaths+=(".");

	ycliPluginsCollectionsDirs=();
	ycliPluginsCollectionsDirs+=($(dirname $YCLI_DIR));
	ycliPluginsCollectionsDirs+=($(echo ~));
	ycliPluginsCollectionsDirs+=($(npm root -g));
	for ycliPluginsCollectionsDir in ${ycliPluginsCollectionsDirs[@]}; do
		for possiblePluginDir in ${ycliPluginsCollectionsDir}/*; do
			if [[ -d ${possiblePluginDir} && $(basename ${possiblePluginDir}) == "$ycliPluginPattern"* ]]; then
				ycliFoundPluginsPaths+=("$possiblePluginDir");
			fi
		done
	done
}

function _ycliAddCommandsForPath {
	for pluginPath in ${ycliPluginsPaths[@]}; do
		scriptDirPath="$pluginPath/ycli-scripts/$1";
		if [ -d ${scriptDirPath} ]; then

			for filePath in ${scriptDirPath}/{*.sh,*.js}; do
				if [ -f "$filePath" ]; then
					fileName=${filePath/$scriptDirPath\//}
					ycliCommand=${fileName%.*};

					if [[ ! " ${ycliCommands[@]} " =~ " $ycliCommand " ]]; then
						ycliCommands+=("$ycliCommand");
					fi
				fi
			done

		fi
	done
}

function _ycliGetPath {
	for pluginPath in ${ycliPluginsPaths[@]}; do
		filePath="$pluginPath/ycli-scripts/$1";
		if [ -f ${filePath} ]; then
			echo "$filePath";
			return 0;
		fi
	done
}

function _ycliRun {
	length=$(($#))
	params=$@
	scriptParamsPath=${params// /\/};
	while [ ! -z ${scriptParamsPath} ]; do

		for pluginPath in ${ycliPluginsPaths[@]}; do
			scriptPath="$pluginPath/ycli-scripts/$scriptParamsPath.sh";
			if [ -f ${scriptPath} ]; then
				shift ${length};
				source ${scriptPath};
				return;
			fi
			nodeScriptPath="$pluginPath/ycli-scripts/$scriptParamsPath.js";
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
	if [ -n "$BASH_VERSION" ]; then
		if [ ${ycliSubCli} == 0 ]; then
			ycliName="ycli";
			ycliLongName="Your/Yo CLI";
			ycliPluginsPaths=(${ycliFoundPluginsPaths[@]});
			ycliPluginsPaths+=("$YCLI_DIR");
		fi

		ycliCommands=();
		_ycliAddCommandsForPath ".";

		if [[ -z "$1" || "$1" == "--help" ]]; then
			_ycliRun help

		else
			if [ "$1" == "ycliCommands" ]; then
				echo "${ycliCommands[@]}";

			else
				_ycliRun "$@"
			fi
		fi

	else
		currentDir=$(pwd);
		bash -i -c "cd $currentDir && ycli $(printf "'%s' " "$@")"

	fi
}

_ycliFindPlugins
