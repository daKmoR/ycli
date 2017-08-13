#!/bin/bash

__ycli() {
	local cur prev

	cur=${COMP_WORDS[COMP_CWORD]}

	case ${COMP_CWORD} in
		1)
			COMPREPLY=($(compgen -W "$(ycli ycliCommands)" ${cur}))
			;;
		2)
			prev=${COMP_WORDS[COMP_CWORD-1]}
			COMPREPLY=($(compgen -W "$(ycli ${prev} ycliCommands)" ${cur}))
			;;
		3)
			prev=${COMP_WORDS[COMP_CWORD-1]}
			prevPrev=${COMP_WORDS[COMP_CWORD-2]}
			case ${prevPrev} in
				*)
					COMPREPLY=($(compgen -W "$(ycli ${prevPrev} ${prev} ycliCommands)" ${cur}))
					;;
			esac
			;;
		4)
			prev=${COMP_WORDS[COMP_CWORD-1]}
			prevPrev=${COMP_WORDS[COMP_CWORD-2]}
			prevPrevPrev=${COMP_WORDS[COMP_CWORD-3]}
			case ${prevPrevPrev} in
				*)
					COMPREPLY=($(compgen -W "$(ycli ${prevPrevPrev} ${prevPrev} ${prev} ycliCommands)" ${cur}))
					;;
			esac
			;;
		*)
			COMPREPLY=()
			;;
	esac
}

# complete is a bash builtin, but recent versions of ZSH come with a function
# called bashcompinit that will create a complete in ZSH. If the user is in
# ZSH, load and run bashcompinit before calling the complete function.
if [[ -n ${ZSH_VERSION-} ]]; then
  autoload -U +X bashcompinit && bashcompinit
fi

complete -F __ycli ycli
