#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	echo "major minor patch pre remove-pre"
	return;
fi

currentDir=$(pwd);
jsonFiles=("${currentDir}/package.json" "${currentDir}/bower.json");
textFiles=("${currentDir}/README.md");

optionSkipSecurityCheck=0;
parameters=($@);
i=0;
for parameter in "${parameters[@]}"; do
	((i++));
	if [[ "$parameter" == "--skip-security-check" || "$parameter" == "-s" ]]; then
		optionSkipSecurityCheck=1;
		unset parameters[$(( i - 1 ))];
	fi
	if [[ "$parameter" == "--help" ]]; then
		echo "";
		echo "Bump Version";
		echo "";
		echo "This will bump your version in your package.json, bower.json, Readme.md";
		echo "";
		echo "Commands:";
		echo "  major: "
		echo "    1.3.12 becomes 2.0.0";
		echo "  minor: ";
		echo "    1.3.12 becomes 1.4.0";
		echo "  patch: ";
		echo "    1.3.12 becomes 1.3.13";
		echo "  pre: ";
		echo "    1.3.12 becomes 1.3.12-pre.1";
		echo "    1.3.12-pre.1 becomes 1.3.12-pre.2";
		echo "  remove-pre: ";
		echo "    1.3.12 becomes 1.3.12";
		echo "    1.3.12-pre.1 becomes 1.3.12";
		echo "";
		echo "Options:";
		echo "  -s --skip-security-check: ";
		echo "    will not check if there is an actually change to be release";
		echo "";
		echo "Examples:";
		echo "  bump-version";
		echo "    => bumps patch version [is default]";
		echo "  bump-version major";
		echo "    => bumps to new major version";
		echo "  bump-version remove-pre --skip-security-check";
		echo "    => removes pre (also if there are no other changes at all)";
		echo "";
		return;
	fi
done

if [[ -z ${parameters[0]} ]]; then
	parameters[0]="patch";
fi

currentVersion=$(ycli release get-current-version);
if [[ -z "$currentVersion" ]]; then
	return 1;
fi
currentSemVer=$(echo ${currentVersion} | grep -o "^[0-9]*\.[0-9]*\.[0-9]*");


#
# Checking if the release actually has changes
#
if [[ ${optionSkipSecurityCheck} == 0 ]]; then
	remoteStatus=$(ycli git remote-status)

	if [[ "$remoteStatus" == "need-to-pull" || "$remoteStatus" == "diverged" ]]; then
		echo "[ERROR] Your local git is not up to date - use git pull";
		return 1;
	fi

fi

#
# pre, remove-pre
#
if [ "${parameters[0]}" == "pre" ]; then
	currentPre=$(echo ${currentVersion} | grep -o pre\.*);
	currentPreNumber=$(echo ${currentPre} | grep -o [0-9]*);
	newPreNumber=$((currentPreNumber + 1));
	newPre="pre.$newPreNumber";
	newVersion="$currentSemVer-$newPre";
fi

if [ "${parameters[0]}" == "remove-pre" ]; then
	newVersion="$currentSemVer";
fi

#
# major, minor, patch
#
if [[ "${parameters[0]}" == "major" || "${parameters[0]}" == "minor" || "${parameters[0]}" == "patch" ]]; then
	major=$(echo ${currentSemVer} | grep -o "^[0-9]*");
	minor=$(echo ${currentSemVer} | grep -o "\.[0-9]*\." | grep -o "[0-9]");
	patch=$(echo ${currentSemVer} | grep -o "[0-9]*$");
fi

if [ "${parameters[0]}" == "major" ]; then
	((major++))
	minor=0;
	patch=0;
fi
if [ "${parameters[0]}" == "minor" ]; then
	((minor++))
	patch=0;
fi
if [ "${parameters[0]}" == "patch" ]; then
	((patch++))
fi

if [[ "${parameters[0]}" == "major" || "${parameters[0]}" == "minor" || "${parameters[0]}" == "patch" ]]; then
	newVersion="$major.$minor.$patch";
fi

#
# write new version to jsonFiles
#
ycli util json set version ${newVersion} --files ${jsonFiles[@]}

#
# write new version to textFiles
#
for textFile in "${textFiles[@]}"; do
	if [[ -f ${textFile} ]]; then
		if grep -q ${currentVersion} ${textFile}; then
			sed -i "s/${currentVersion}/${newVersion}/g" ${textFile}
			echo "[CHANGE] File $textFile has been touched :: String Replace \"$currentVersion\" to \"$newVersion\"";
		fi
	fi
done
