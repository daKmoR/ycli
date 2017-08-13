#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	echo $(git branch | cut -c 3-)
	return;
fi
if [ "$2" == "ycliCommands" ]; then
	echo $(git branch | cut -c 3-)
	return;
fi
if [ "$3" == "ycliCommands" ]; then
	return;
fi

for parameter in "$@"; do
	if [[ "$parameter" == "--help" ]]; then
		echo "";
		echo "GitLab Create Merge Request";
		echo "";
		echo "This will create a merge request.";
		echo "";
		echo "Parameters:";
		echo "  <source-branch> [Defaults to current branch]:"
		echo "    The Branch name you wish to create a merge from";
		echo "  <target-branch> [Defaults to master]: ";
		echo "    The Branch name you wish to merge into";
		echo "  <branch-title> [Defaults to \"Merge Request for <source-branch>\"]: ";
		echo "    The Branch name you wish to merge into";
		echo "";
		echo "Examples:";
		echo "  create-merge-request";
		echo "    => Creates a merge from <current branch> to master with title \"Merge Request for <current branch>\"";
		echo "  create-merge-request feature/myOtherFeature";
		echo "    => Creates a merge from feature/myOtherFeature to master with title \"Merge Request for feature/myOtherFeature\"";
		echo "  create-merge-request fix master \"Please merge me\"";
		echo "    => Creates a merge from fix to master with title \"Please merge me\"";
		echo "";
		return;
	fi
done

source $YCLI_DIR/scripts/git/api.sh

projectName=$(git remote show origin -n | grep Fetch.URL | sed 's/.*:[0-9]*\///;s/.git$//')
projectNameEscaped=$(echo $projectName | sed s#/#%2F#g);

if [[ -z $projectNameEscaped ]]; then
	echo "[ERROR] Not in a valid git repo";
fi

sourceBranch=$1;
targetBranch=$2;
title=$3;

if [[ -z "$sourceBranch" ]]; then
	sourceBranch=$(git rev-parse --abbrev-ref HEAD);
fi
if [[ -z "$targetBranch" ]]; then
	targetBranch="master";
fi
if [[ -z "$title" ]]; then
	title="Merge Request for $sourceBranch";
fi

if [[ "$sourceBranch" == "$targetBranch" ]]; then
	echo "[ERROR] Source and Target Branch needs to be different for a merge request";
	echo "SourceBranch: $sourceBranch";
	echo "TargetBranch: $targetBranch";
	return;
fi

if ! git branch --list -r | grep -q "origin/${sourceBranch}\$"; then
	git checkout "$sourceBranch"
	git push -u origin "$sourceBranch"
fi

# https://docs.gitlab.com/ce/api/merge_requests.html

jsonData="{";

jsonData+='"id": "';
jsonData+="$projectNameEscaped";
jsonData+='"';

jsonData+=', "source_branch": "';
jsonData+="$sourceBranch";
jsonData+='"';

jsonData+=', "target_branch": "';
jsonData+="$targetBranch";
jsonData+='"';

jsonData+=', "title": "';
jsonData+="$title";
jsonData+='"';

jsonData+=', "remove_source_branch": "true"';

jsonData+="}";

_ycliStartTime
echo "[START] GitLab Create Merge Request \"$title\" merging \"$sourceBranch\" into \"$targetBranch\" for \"$projectName\"";
echo "";

curl -k --header "PRIVATE-TOKEN: $gitLabToken" --header "Content-Type: application/json" -X POST -d "$jsonData" "${gitLabUrl}api/v4/projects/$projectNameEscaped/merge_requests"

_ycliEndTime
echo "";
echo "[DONE] Create Merge Request Duration: $(printf %.2f $_ycliDuration)s";
