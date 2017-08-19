#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	exit;
fi

echo
echo "$ycliLongName"
echo
echo "Available Commands:"
for ycliCommand in ${ycliCommands[@]};	do
	echo "    $ycliName $ycliCommand";
done
echo
echo "Example:"
echo "    $ycliName self-update"
echo
