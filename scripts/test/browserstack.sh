#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	ycliCommands="login list";
	_ycliAddCommandsFromPath "$YCLI_DIR/scripts/test/browserstack" js;
	_ycliAddCommandsFromPath "./scripts/test/browserstack" js;
	echo $ycliCommands;
	return;
fi
if [ "$2" == "ycliCommands" ]; then
	return;
fi

optionSave=0;
optionSaveFilePath=".tmp/_lastBrowserStackTestResult.txt";
parameters=($@);
i=0;
for parameter in ${parameters[@]}; do
	((i++));
	if [[ "$parameter" == "--save" || "$parameter" == "-s" ]]; then
		optionSave=1;
		unset parameters[$(( i - 1 ))];
	fi
	if [[ "$parameter" == "--save-file-path" || "$parameter" == "-f" ]]; then
		n=$((i+1));
		optionSaveFilePath=${!n};
		unset parameters[$(( i - 1 ))];
		unset parameters[$(( i ))];
	fi
	if [[ "$parameter" == "--help" ]]; then
		echo "";
		echo "Browserstack Testing";
		echo "";
		echo "This allows you to run the elements test via BrowserStack.";
		echo "";
		echo "Commands:";
		echo "  login: "
		echo "    Reenter your BrowserStack credential";
		echo "  list: ";
		echo "    Fetching an up to date browser list from BrowserStack via curl"
		echo "    See spec for api https://github.com/browserstack/api";
		echo "";
		echo "Options:";
		echo "  -s --save: ";
		echo "    save the output of BrowserStack to a file";
		echo "  -f --save-file-path: ";
		echo "    where to save the output [Defaults to '.tmp/_lastBrowserStackTestResult.txt']";
		echo "";
		echo "Examples:";
		echo "  browserstack chrome-latest-windows-10";
		echo "    => run the tests only for latest chrome on windows 10";
		echo "  browserstack --save";
		echo "    => runs the test and saves the output to the file";
		echo "  browserstack list > browsers.json";
		echo "    => fetches latest browser list and saves it to a file";
		echo "";
		return;
	fi
done

npmRoot=$(npm root -g);
webComponentTesterCustomRunnerPath="$npmRoot/web-component-tester-custom-runner"
wctBrowserstack="$npmRoot/wct-browserstack"

if [[ ! -d "$webComponentTesterCustomRunnerPath" || ! -d "$wctBrowserstack" ]]; then
	echo "[ERROR] Not properly installed";
	echo "You have to run";
	echo "npm install -g web-component-tester-custom-runner wct-browserstack";
	return 1;
fi



[ -s ~/.browserstackconfig ] && source ~/.browserstackconfig
if [[ -z "$username" || -z "$accessKey" || ${parameters[0]} == "login" ]]; then
	echo "Login to Browserstack:"
	echo "You can find your login at https://www.browserstack.com/accounts/settings all the way at the bottom"
	read -p 'Username: ' username
	read -p 'Access Keys: ' accessKey
	echo "username=$username" >> ~/.browserstackconfig
	echo "accessKey=$accessKey" >> ~/.browserstackconfig
fi

if [[ -z "$username" || -z "$accessKey" ]]; then
	echo "No Login No Usage";
	return 1;
fi

# Setting it globally for the npm module
export BROWSER_STACK_USERNAME=$username
export BROWSER_STACK_ACCESS_KEY=$accessKey

if ! nc -z browserstack.com 80 2>/dev/null; then
	echo "[ERROR] browserstack.com is unreachable";
	return;
fi

if [[ "${parameters[0]}" == "list" ]]; then
	curl -u "$BROWSER_STACK_USERNAME:$BROWSER_STACK_ACCESS_KEY" https://api.browserstack.com/4/browsers?flat=true
	return;
fi


_ycliStartTime
echo "[START] Test Browserstack";
echo "";

myDir=$(pwd)

if [ -f "${parameters[0]}" ]; then
	configFile="${parameters[0]}";

else
	config="${parameters[0]}";
	if [ -z "$config" ]; then
		config="desktop-fast";
	fi

	configFile="$YCLI_DIR/scripts/test/browserstack/$config.js"
	if [ ! -f "$configFile" ]; then
		echo "[ERROR] No Config file found at $configFile";
		return 1;
	fi
fi


if [[ $optionSave == 1 ]]; then
	mkdir -p $(dirname  "$optionSaveFilePath")
	wct --configFile $configFile --root $myDir > "$optionSaveFilePath"
else
	wct --configFile $configFile --root $myDir
fi

_ycliEndTime
echo "";
echo "[DONE] Test Duration: $(printf %.2f $_ycliDuration)s";
