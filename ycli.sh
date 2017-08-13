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

function _ycliAddCommandsFromPath {
	path=$1;
	if [ ! -d $path ]; then
		return;
	fi

	fileExtension="sh";
	if [ ! -z "$2" ]; then
		fileExtension="$2";
	fi

	for file in $path/*.$fileExtension; do
		ycliCommand=${file/$path\//}
		ycliCommand=${ycliCommand/\.$fileExtension/}
		if [[ ! $ycliCommands == *"$ycliCommand "* ]]; then
			ycliCommands="$ycliCommands $ycliCommand ";
		fi
	done
}

function _ycliRun {
	length=$(($#))
	params=$@
	scriptPath=${params// /\/};
	while [ ! -z $scriptPath ]; do
		globalScriptPath="$YCLI_DIR/scripts/$scriptPath.sh"
		localScriptPath="./scripts/$scriptPath.sh"
		if [ -f $localScriptPath ]; then
			shift $length;
			source $localScriptPath;
			return;
		else
			if [ -f $globalScriptPath ]; then
				shift $length;
				source $globalScriptPath;
				return;
			fi
		fi
		length=$((length-1));
		params=${@:1:$length}
		scriptPath=${params// /\/}
	done

	echo "[ERROR] Command $scriptPath not found";
	return;
}

function ycli() {
	if [ "$(ps -p "$$" -o comm=)" != "bash" ]; then
		bash -c "\. \"$YCLI_DIR/ycli.sh\" && \. \"$YCLI_DIR/bash_completion.sh\" && ycli $(printf "'%s' " "$@")"
	else
		ycliCommands="";
		_ycliAddCommandsFromPath "$YCLI_DIR/scripts";
		_ycliAddCommandsFromPath "./scripts";

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
