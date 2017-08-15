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

[ -s ~/.ycligitlabapiconfig ] && source ~/.ycligitlabapiconfig
if [[ -z $gitLabToken || -z $gitLabUrl || $1 == "login" ]]; then
	echo "Login to Gitlab:"
	read -p 'Gitlab Url: ' gitLabUrl
	if [[ ! ${gitLabUrl: -1} == "/" ]]; then
		gitLabUrl="$gitLabUrl/";
	fi
	echo "You can find your login at ${gitLabUrl}profile/account"
	read -p 'Gitlab Private Token: ' gitLabToken

	echo "" > ~/.ycligitlabapiconfig
	echo "gitLabToken=$gitLabToken" >> ~/.ycligitlabapiconfig
	echo "gitLabUrl=$gitLabUrl" >> ~/.ycligitlabapiconfig
fi

if [[ -z "$gitLabToken" || -z "$gitLabUrl" ]]; then
	echo "No Login No Usage";
	return 1;
fi
