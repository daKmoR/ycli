#!/bin/bash

#
# Bash Autocomplete
#
if [ "1" == "ycliCommands" ]; then
	return;
fi

if [ -z "${ycliMultipleResumeElements[@]}" ]; then
	echo '[ERROR] You can only resume if a "ycli multiple <your command>" did not finish before';
	echo "";
	return;
fi

ycliMultipleElements=(${ycliMultipleResumeElements[@]});

ycli multiple "$ycliMultipleResumeCommand"
