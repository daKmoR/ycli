#!/bin/bash
#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	ycliCommands=();
	_ycliAddCommandsForPath "multiple";
	echo "${ycliCommands[@]}";
	return;
fi
if [ "${@: -1}" == "ycliCommands" ]; then
	return;
fi

optionJobs=1;
parameters=($@);
ycliMultipleNr=0;
for parameter in ${parameters[@]}; do
	((ycliMultipleNr++));
	if [[ "$parameter" == "--jobs" || "$parameter" == "-j" ]]; then
		n=$((ycliMultipleNr+1));
		optionJobs=${!n};
		if [[ ! ${optionJobs} =~ ^-?[0-9]+$ || ! ${optionJobs} -gt 0 ]]; then
			echo "[ERROR] Your have to provide the amount of parallel jobs that should run as a number > 0 e.g. --jobs 2";
			return 1;
		fi
		unset parameters[$(( ycliMultipleNr - 1 ))];
		unset parameters[$(( ycliMultipleNr ))];
	fi
	if [[ "$parameter" == "--help" ]]; then
		ycli multiple help
		return;
	fi
done

if [ -z "$ycliMultipleElements" ]; then
	echo "[ERROR] You have to set provide elements e.g. $ycliName multiple add iron-*";
	echo "[INFO] bash combinator like {iron-*,paper-*] is supported";
	return 1;
fi

if [ -z "$1" ]; then
	echo "[ERROR] You have to provide a command to run e.g. $ycliName multiple execute pwd";
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

numberAll=${#ycliMultipleElements[@]};
currentDir=$(pwd)

echo "[START] Do \"${parameters[@]}\" for the following $numberAll components";
for componentRoot in ${ycliMultipleElements[@]}; do
	echo "- $componentRoot";
done

#
# Sequential Execution
#
if [[ ${optionJobs} == 1 ]]; then
	ycliMultipleResumeElements=${ycliMultipleElements[@]};
	ycliMultipleResumeCommand="${parameters[@]}";

	ycliMultipleNr=0;
	for componentRoot in ${ycliMultipleElements[@]}; do
		((ycliMultipleNr++))
		echo "[START] ($ycliMultipleNr/$numberAll) Component $componentRoot";

		cd $componentRoot
		eval "${parameters[@]}"
		ycliMultipleResumeElements="${ycliMultipleResumeElements[@]/$componentRoot}";

		echo "[DONE] ($ycliMultipleNr/$numberAll) Component $componentRoot";
		echo "";
	done

	ycliMultipleResumeElements=();
fi

#
# Parallel Execution
#
if [[ ${optionJobs} -gt 1 ]]; then
	parallelCommand="";
	for cliPath in ${ycliCliPaths[@]}; do
		parallelCommand+="source $cliPath; ";
	done
	parallelCommand+="cd {1}; ";
	parallelCommand+="echo \"[START] ({#}/$numberAll) Component {1}\"; ";
	parallelCommand+="${parameters[@]}; ";
	parallelCommand+="echo \"[DONE] ({#}/$numberAll) Component {1}\"; ";
	parallelCommand+="echo \"\"; ";

	parallel -k -j ${optionJobs} "${parallelCommand}" ::: ${ycliMultipleElements[@]}
fi

cd ${currentDir}

_ycliEndTime
echo "[DONE] Multiple Actions Duration: $(printf %.2f $_ycliDuration)s";
