#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

echo "
Multiple actions

It allows you to easily execute a command for a filtered list of folders.

Hint: use the following command to select all ing and iron elements
ycli multiple set-filter iron-*

Example Usage:

Demo Structure:
/html/iron-button-styles
/html/iron-input-styles
/html/paper-pagination

== Simple Example ==
cd /html/
ycli multiple set-filter iron-*
ycli multiple pwd

Will result in
[START] Do \"pwd\" for the following components
- iron-button-styles
- iron-input-styles
[START] Component iron-button-styles
/html/iron-button-styles
[DONE] Component iron-button-styles
[START] Component iron-input-styles
/html/iron-input-styles
[DONE] Component iron-input-styles

== Full Example with branch and push ==
1) Go to the parent folder
cd /html/

2) Set a filter for which folders should be taken into account
ycli multiple set-filter iron-*

3) Optional: Reset all folders, create/checkout branch, pull latest version
ycli multiple prepare my-feature-branch-name

4) the command you wish to do
ycli multiple ycli upgrade

5) Add all to git
ycli multiple git add .

6) Do a commit for every element (Use ' instead of \")
ycli multiple git commit -m '[TASK] Run Upgrade'

7) Push the changes
ycli multiple git push origin my-feature-branch-name
OR if not using branches
ycli multiple git push

8) Optional: Create a Pull Request
ycli multiple ycli git-lab create-merge-request
"
