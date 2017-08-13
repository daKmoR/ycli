#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

if ! hash wct 2>/dev/null; then
	echo "[ERROR] wct not available pls install via npm install -g web-component-tester."
	return;
fi

echo "[START] Testing $(pwd)";
_ycliStartTime

echo "";
wct --skip-selenium-install $@

_ycliEndTime
echo "";
echo "[DONE] Test Duration: $(printf %.2f $_ycliDuration)s";
