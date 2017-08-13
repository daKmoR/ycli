#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	echo "major minor patch pre"
	return;
fi

remoteStatus=$(_ycliRun git remote-status)

if [[ "$remoteStatus" == "need-to-pull" || "$remoteStatus" == "diverged" ]]; then
	echo "[ERROR] Your local git is not up to date - use git pull";
	return 1;
fi

if [[ "$remoteStatus" == "up-to-date" ]]; then
	if git diff-index --quiet HEAD --; then
		if git diff -s --exit-code origin/master; then
			echo "[ERROR] Nothing changed in comparison to remote - abort";
			return 1;
		fi
	fi
fi

currentDir=$(pwd);

if [ "$1" == "pre" ]; then
	currentVersion=$(ycli util json ${currentDir}/package.json get version);
	currentSemVer=$(echo ${currentVersion} | grep -o "^[0-9]*\.[0-9]*\.[0-9]*");
	currentPre=$(echo ${currentVersion} | grep -o pre\.*);
	currentPreNumber=$(echo ${currentPre} | grep -o [0-9]*);
	newPreNumber=$((currentPreNumber + 1));
	newPre="pre.$newPreNumber";
	newVersion="$currentSemVer-$newPre";

	ycli util json ${currentDir}/bower.json set version ${newVersion}
	ycli util json ${currentDir}/package.json set version ${newVersion}
fi

if [[ "$1" == "major" || "$1" == "minor" || "$1" == "patch" ]]; then
	currentVersion=$(ycli util json ${currentDir}/package.json get version);
	currentSemVer=$(echo ${currentVersion} | grep -o "^[0-9]*\.[0-9]*\.[0-9]*");

	major=$(echo ${currentSemVer} | grep -o "^[0-9]*");
	minor=$(echo ${currentSemVer} | grep -o "\.[0-9]*\." | grep -o "[0-9]");
	patch=$(echo ${currentSemVer} | grep -o "[0-9]*$");
fi

if [ "$1" == "major" ]; then
	((major++))
fi
if [ "$1" == "minor" ]; then
	((minor++))
fi
if [ "$1" == "patch" ]; then
	((patch++))
fi

if [[ "$1" == "major" || "$1" == "minor" || "$1" == "patch" ]]; then
	newVersion="$major.$minor.$patch";
	ycli util json ${currentDir}/bower.json set version ${newVersion}
	ycli util json ${currentDir}/package.json set version ${newVersion}
fi
