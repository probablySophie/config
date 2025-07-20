
__tmux_commands=();
__tmux_descriptions=();

function __tmux_register
{
	__tmux_commands+=("$1");
	__tmux_descriptions+=("$2");
}

if command -v tmux --help &> /dev/null
then
	__tmux_register "save" "Save the current tmux layout"
	__tmux_register "load" "load the currently saved"
	
	_tmuxx()
	{
		if [[ "$1" == "save" ]]; then
			. "$__BASH_CONFIG_PATH/tmux/save_session.sh";
			return
		fi
		
		if [[ "$1" == "load" ]]; then
			. "$__BASH_CONFIG_PATH/tmux/load_session.sh";
			return
		fi

		# TODO: A print command?
		
		# If there are no arguments
		if [ $# -eq 0 ]; then
			printf "tmuxx {arg}\n"
		else
			printf "Bad argument: $1\n";
			printf "Valid arguments: \n";
		fi

		local i=0;
		for (( i=0; i<${#__tmux_commands[@]}; i++ )); do
			printf "\t${__tmux_commands[$i]} - ${__tmux_descriptions[$i]}\n";		
		done
		
	}
fi

descriptive_alias "tmuxx" "_tmuxx" "Set up our preferred tmux layout!"

