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

[ -s ~/.gitlabconfig ] && source ~/.gitlabconfig
if [[ -z "$gitLabToken" || $1 == "login" ]]; then
	echo "Login to Gitlab:"
	read -p 'Gitlab Url: ' gitLabUrl
	if [[ ! ${gitLabUrl: -1} == "/" ]]; then
		gitLabUrl="$gitLabUrl/";
	fi
	echo "You can find your login at ${gitLabUrl}profile/account"
	read -p 'Gitlab Private Token: ' gitLabToken

	echo "gitLabToken=$gitLabToken" > ~/.gitlabconfig
	echo "gitLabUrl=$gitLabUrl" > ~/.gitlabconfig
fi

if [[ -z "$gitLabToken" || -z "$gitLabUrl" ]]; then
	echo "No Login No Usage";
	return 1;
fi
