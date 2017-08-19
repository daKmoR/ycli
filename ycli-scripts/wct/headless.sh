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

if [[ -z ${ycliWctResultFilePath} ]]; then
	ycliWctResultFilePath=$(ycli config get wct.resultFilePath);
fi

optionSave=0;
optionSaveFilePath="$ycliWctResultFilePath";
parameters=($@);
i=0;
for parameter in ${parameters[@]}; do
	((i++));
	if [[ "$parameter" == "--save" || "$parameter" == "-s" ]]; then
		optionSave=1;
		unset parameters[$(( i - 1 ))];
	fi
	if [[ "$parameter" == "--save-file-path" || "$parameter" == "-f" ]]; then
		n=$((i+1));
		optionSaveFilePath=${!n};
		unset parameters[$(( i - 1 ))];
		unset parameters[$(( i ))];
	fi
	if [[ "$parameter" == "--help" ]]; then
		echo "";
		echo "Headless Testing";
		echo "";
		echo "This allows you to run the element test via Headless Browsers.";
		echo "";
		echo "Options:";
		echo "  -s --save: ";
		echo "    save the output of the test to a file";
		echo "  -f --save-file-path: ";
		echo "    where to save the output [Defaults to '$ycliWctResultFilePath']";
		echo "";
		echo "Examples:";
		echo "  headless";
		echo "    => run the test for chrome";
		echo "  headless both --save";
		echo "    => runs the test for chrome and firefox and saves the output to the file";
		echo "";
		return;
	fi
done

addToCommand="${parameters[@]}";
browser="${parameters[0]}";
if [[ "${parameters[0]}" == "chrome" || "${parameters[0]}" == "firefox" || "${parameters[0]}" == "both" ]]; then
	unset parameters[0];
	addToCommand="${parameters[@]}";
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

if [[ ${optionSave} == 1 ]]; then
	mkdir -p $(dirname  "$optionSaveFilePath")
	xvfb-run wct --skip-selenium-install ${addToCommand} | tee "$optionSaveFilePath"
	echo "";
	echo "[INFO] Results have been written to $optionSaveFilePath";

else
	xvfb-run wct --skip-selenium-install ${addToCommand}

fi

_ycliEndTime
echo "[DONE] Test Duration: $(printf %.2f $_ycliDuration)s";
