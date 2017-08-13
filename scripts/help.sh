#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	exit;
fi

echo
echo "Your/Yo CLI"
echo
echo "Available Commands:"
for ycliCommand in $ycliCommands;	do
	echo "    ycli $ycliCommand";
done
echo
echo "Example:"
echo "    ycli self-update"
echo
