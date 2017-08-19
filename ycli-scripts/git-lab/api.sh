#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	echo "login";
	return;
fi
if [ "$2" == "ycliCommands" ]; then
	return;
fi

if [[ -z ${ycliGitLabApiToken} || -z ${ycliGitLabApiUrl} ]]; then
	ycliGitLabApiToken=$(ycli config get git-lab.api.token);
	ycliGitLabApiUrl=$(ycli config get git-lab.api.url);
fi

if [[ -z ${ycliGitLabApiToken} || -z ${ycliGitLabApiUrl} || $1 == "login" ]]; then
	echo "Login to Gitlab:"
	read -p 'Gitlab Url: ' ycliGitLabApiUrl
	if [[ ! ${ycliGitLabApiUrl: -1} == "/" ]]; then
		ycliGitLabApiUrl="$ycliGitLabApiUrl/";
	fi
	echo "You can find your login at ${ycliGitLabApiUrl}profile/account"
	read -p 'Gitlab Private Token: ' ycliGitLabApiToken

	if [[ -z "$ycliGitLabApiToken" || -z "$ycliGitLabApiUrl" ]]; then
		echo "[ERROR] No Login No Usage";
		return 1;
	fi

	ycli config set-global git-lab.api.url "$ycliGitLabApiUrl"
	ycli config set-global git-lab.api.token "$ycliGitLabApiToken"

	return 0;
fi
