#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	echo "chrome firefox both"
	return;
fi

if ! hash xvfb-run 2>/dev/null; then
	echo "[ERROR] xvfb is not available - pls install via sudo apt-get install xvfb."
	return;
fi

addToCommand="$@";
browser="$1";
if [[ "$1" == "chrome" || "$1" == "firefox" || "$1" == "both"  ]]; then
	shift 1
	addToCommand="$@";
fi

if [ -z "$browser" ]; then
	browser="chrome";
fi
if [[ "$browser" == "chrome" || "$browser" == "both" ]]; then
	addToCommand+=" -l chrome";
fi
if [[ "$browser" == "firefox" || "$browser" == "both" ]]; then
	addToCommand+=" -l firefox";
fi

echo "[START] Testing $(pwd)";
_ycliStartTime
echo "";

xvfb-run wct --skip-selenium-install $addToCommand

_ycliEndTime
echo "[DONE] Test Duration: $(printf %.2f $_ycliDuration)s";
