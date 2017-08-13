#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

if [ -z $1 ]; then
	echo "[ERROR] You have to provide a branch name e.g. ycli git reset-to-branch-update development";
	return;
fi

git checkout .
git fetch --all

if git branch --list -r | grep -q "origin/${1}\$"; then
	git checkout $1
	git pull
	git reset --hard origin/$1
	git clean -f
else
	git checkout -b $1
fi
