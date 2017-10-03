#!/bin/bash

if [ ! -f ~/.bashrc ]; then
	if [ ! -f ~/.profile ]; then
		echo "[ERROR] No ~/.profile found - is your bash correctly setup?";
		echo "[INFO] Empty ~./profile created";
		touch ~/.profile
	fi

	echo "[INFO] ~/.bashrc missing will be created and liked in ~/.profile";
	touch ~/.bashrc
	echo '
# if running bash
if [ -n "$BASH_VERSION" ]; then
		# include .bashrc if it exists
		if [ -f "$HOME/.bashrc" ]; then
				source "$HOME/.bashrc"
		fi
fi' >> ~/.profile
fi

installDir=$(pwd);
sourceString="\nexport YCLI_DIR=\"${installDir}\"\n[ -s \"\$YCLI_DIR/ycli.sh\" ] && \\. \"\$YCLI_DIR/ycli.sh\"  # This loads ycli\n"
completionString="[ -s \"\$YCLI_DIR/bash_completion.sh\" ] && \\. \"\$YCLI_DIR/bash_completion.sh\"  # This loads ycli bash_completion\n"

if ! command grep -cq '/ycli.sh' ~/.bashrc; then
	command printf "${sourceString}" >> ~/.bashrc
	command printf "${completionString}" >> ~/.bashrc

	echo "[FINISHED] Setup ycli in ~/.bashrc";
	echo "Please restart your terminal/command line [or execute \"source ~/.bashrc\"]";
else
	echo "[INFO] ycli is already present in ~/.bashrc - no action taken";
fi

if [ -f ~/.zshrc ]; then
	if ! command grep -cq '/ycli.sh' ~/.zshrc; then
			command printf "${sourceString}" >> ~/.zshrc
			command printf "${completionString}" >> ~/.zshrc

			echo "[FINISHED] Setup ycli in ~/.zshrc";
			echo "Please restart your terminal/command line  [or execute \"source ~/.zshrc\"]";
		else
			echo "[INFO] ycli is already present in ~/.zshrc - no action taken";
	fi
fi
