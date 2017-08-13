#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

git remote update >/dev/null 2>&1

upstream=${1:-'@{u}'}
local=$(git rev-parse @)
remote=$(git rev-parse "$upstream")
base=$(git merge-base @ "$upstream")

if [ "$local" == "$remote" ]; then
	echo "up-to-date"
elif [ "$local" == "$base" ]; then
	echo "need-to-pull"
elif [ "$remote" == "$base" ]; then
	echo "need-to-push"
else
	echo "diverged"
fi
