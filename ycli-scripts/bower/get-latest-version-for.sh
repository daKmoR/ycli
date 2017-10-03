#!/bin/bash

#
# Bash Autocomplete
#
if [ "$1" == "ycliCommands" ]; then
	return;
fi

bower info "$1" 2>/dev/null | grep -A1 'Available versions:' | tail -n 1 | sed -r 's/^.{4}//'
