#!/bin/bash

if [ ! -f ~/.bashrc ]; then
	echo "[INFO] ~/.bashrc missing are you sure ycli is installed";
fi

if command grep -cq 'YCLI_DIR' ~/.bashrc; then
	command sed -i "/YCLI_DIR/d" ~/.bashrc
	echo "[FINISHED] Remove Setup of ycli in ~/.bashrc"
	echo "Please restart your terminal/command line";
fi

if [ -f ~/.zshrc ]; then
	if command grep -cq 'YCLI_DIR' ~/.zshrc; then
		command sed -i "/YCLI_DIR/d" ~/.zshrc
		echo "[FINISHED] Remove Setup of ycli in ~/.zshrc"
		echo "Please restart your terminal/command line";
	fi
fi
