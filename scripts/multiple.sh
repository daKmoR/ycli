#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	ycliCommands="";
	_ycliAddCommandsFromPath "$YCLI_DIR/scripts/multiple";
	_ycliAddCommandsFromPath "./scripts/multiple";
	echo $ycliCommands;
	return;
fi
if [ "${@: -1}" == "ycliCommands" ]; then
	return;
fi

optionJobs=4;
optionSaveFilePath=".tmp/_lastBrowserStackTestResult.txt";
parameters=($@);
i=0;
for parameter in ${parameters[@]}; do
	((i++));
	if [[ "$parameter" == "--jobs" || "$parameter" == "-j" ]]; then
		n=$((i+1));
		optionJobs=${!n};
		if [[ ! ${optionJobs} =~ ^-?[0-9]+$ || ! ${optionJobs} -gt 0 ]]; then
			echo "[ERROR] Your have to provide the amount of parallel jobs that should run as a number > 0 e.g. --jobs 2";
			return 1;
		fi
		unset parameters[$(( i - 1 ))];
		unset parameters[$(( i ))];
	fi
	if [[ "$parameter" == "--help" ]]; then
		_ycliRun multiple help
		return;
	fi
done

if [ -z "$_ycliMultipleFilters" ]; then
	echo "[ERROR] You have to set a filter e.g. ycli multiple set-filter iron-*";
	echo "[INFO] bash combinator like {iron-*,paper-*] is supported";
	return 1;
fi

if [ -z "$1" ]; then
	echo "[ERROR] You have to provide a command to run e.g. ycli multiple execute pwd";
	return 1;
fi

if [[ ${optionJobs} -gt 1 ]]; then
	if ! hash parallel 2>/dev/null; then
		echo "";
		echo "[ERROR] parallel not available pls install via apt-get install parallel"
		echo "[INFO] Fallback to Sequential Execution";
		echo "";
		optionJobs=1;
	fi
fi

_ycliStartTime

multipleExecute=($_ycliMultipleFilters);
numberAll=${#multipleExecute[@]};
currentDir=$(pwd)

echo "[START] Do \"${parameters[@]}\" for the following $numberAll components";
for componentRoot in ${multipleExecute[@]}; do
	echo "- $componentRoot";
done

#
# Sequential Execution
#
if [[ ${optionJobs} == 1 ]]; then
	_ycliMultipleResumeElements=${multipleExecute[@]};
	export _ycliMultipleResumeCommand="${parameters[@]}";

	i=0;
	for componentRoot in ${multipleExecute[@]}; do
		((i++))
		echo "[START] ($i/$numberAll) Component $componentRoot";

		cd $componentRoot
		"${parameters[@]}"
		export _ycliMultipleResumeElements="${_ycliMultipleResumeElements[@]/$componentRoot}";

		echo "[DONE] ($i/$numberAll) Component $componentRoot";
		echo "";
	done
fi

#
# Parallel Execution
#
if [[ ${optionJobs} -gt 1 ]]; then
	parallelCommand="";
	parallelCommand+="source $YCLI_DIR/ycli.sh; ";
	parallelCommand+="cd {1}; ";
	parallelCommand+="echo \"[START] ({#}/$numberAll) Component {1}\"; ";
	parallelCommand+="${parameters[@]}; ";
	parallelCommand+="echo \"[DONE] ({#}/$numberAll) Component {1}\"; ";
	parallelCommand+="echo \"\"; ";

	parallel -k -j ${optionJobs} "${parallelCommand}" ::: ${multipleExecute[@]}
fi

cd ${currentDir}

_ycliEndTime
echo "[DONE] Multiple Actions Duration: $(printf %.2f $_ycliDuration)s";
