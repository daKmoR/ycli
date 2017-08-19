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
	status="up-to-date";
elif [ "$local" == "$base" ]; then
	status="need-to-pull"
elif [ "$remote" == "$base" ]; then
	status="need-to-push"
else
	status="diverged"
fi


if [[ "$status" == "up-to-date" ]]; then
	if ! git diff-index --quiet HEAD --; then
		status="local-changes";
		if git diff -s --exit-code origin/master; then
			status="has-commits";
		fi
	fi
fi

echo "$status";
