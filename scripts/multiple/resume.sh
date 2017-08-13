#!/bin/bash

#
# Bash Autocomplete
#
if [ "1" == "ycliCommands" ]; then
	return;
fi

if [ -z $_ycliMultipleResumeElements ]; then
	echo '[ERROR] You can only resume if a "ycli multiple execute <your command>" did not finish before';
	echo "";
	return;
fi

export _ycliMultipleResumeActive=1;

echo $_ycliMultipleResumeElements

_ycliRun multiple execute $_ycliMultipleResumeCommand

