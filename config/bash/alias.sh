#
#	Custom Alias Files
#


# Create an alias that runs a specific file, but ONLY if the file exists
safealias_file() # safealias_file FILEPATH COMMAND
{ 
	if [ -f $1 ]; then
		
		alias $2="${1}"

	fi
	# And custom command descriptions
	if [[ $3 ]]; then
		custom_command "$2" "$3"
	fi
}

descriptive_alias()
{
	alias $1="${2}"
	if [[ $3 ]]; then
		custom_command "$1" "$3"
	fi
}

# Create an alias that runs a specific command, but ONLY if the command exists
# Useful for overwriting default commands with funky drop-in replacements
safealias_command() # safealias_command COMMAND_TO_CHECK ALIAS
{
	if command -v $1 &> /dev/null ; then
		alias $2="${1}"
	fi
	if [[ $3 ]]; then
		custom_command "$2" "$3"
	fi
}

safealias_file $HOME/AppImages/love*.AppImage love "Run Love2D" # Love2D :)

# Recursively get all instances of TODO in (non-hidden) files
descriptive_alias "todo" \
	"grep -r --exclude-dir='.*' --exclude-dir='node_modules' 'TODO:' *" \
	"Recursively list all instances of 'TODO:' in non-hidden files"

alias gitwhoami="git config --list | grep \"user\"" # because I don't want to FULLY dox myself

alias q="exit"	# because I use neovim and am dumb :(
alias :q="exit"
alias qq="exit"

# Rename the current tmux window to the current path
alias tmr="tmux rename-window ${PWD##*/}"

# Get the size of all files & folders in the current dir (and sort by largest)
descriptive_alias "dus" "du -sh --apparent-size * | sort -hr" "Get the sizes of all files & folders in the current dir sorted large -> small"

# Alias top to btm (ClementTsang/bottom)
safealias_command btm top

# Ls → Eza
# Eza is a forked alive version of Exa which is just a nicer ls
if command -v eza &> /dev/null ; then
	descriptive_alias 'll' 'eza -lF --icons' "List non-hidden files in PWD along with all the information you could ever need"
	descriptive_alias 'la' 'eza -aF --icons' "List _all_ files in PWD"
	alias ls='eza --icons'
else # No
	descriptive_alias ll='ls -alF' "List non-hidden files along with more info"
	descriptive_alias la='ls -A' "List all files in PWD"
fi

# Cat → Bat
if command -v bat &> /dev/null ; then
	alias cat='bat'
#else
	# Nothing
fi

descriptive_alias 'pysource' "source .venv/bin/activate" "Source .venv/bin/active (for python)"

# descriptive_alias 'llama' "docker exec -it ollama ollama run llama3" "Run llama3 using ollama"
# descriptive_alias 'codellama' "docker exec -it ollama ollama run codellama" "Run codellama using ollama"

# Use less to view manual pages so we can SCROLLLLLL
alias man="man --pager='less --mouse  --wheel-lines=3'"

# ~ ~ ~ ~ CUSTOM COMMANDS ~ ~ ~ ~

_mkd() { mkdir -p $1; cd $1; } # Make a directory and cd into it
descriptive_alias "mkd" "_mkd" "Make a new directory and CD into it"

_weather() { curl "https://wttr.in/$1?format=%l:+%C+%t+%x\nFeels+like+%f\nUV+index:+%u\nCurrent+Rain:+%p" ;}
descriptive_alias "weather" '_weather' "Get the current weather in \$1!"

descriptive_alias "escape_spaces" "sed -e 's/ /\\\\\\ /g' -e 's/&/\\&/g'" "Escape spaces from the piped in input"

# TUI clone one of my github repos
# Requres fzf for the TUI niceness & gh for the github part
if command -v fzf &> /dev/null ; then
	if command -v gh &> /dev/null ; then
		descriptive_alias "clone" "gh repo list -L 100"\
"| fzf "\
"| sed 's/[ \t].*//g' "\
"| xargs -I {} gh repo clone {} --recurse-submodules" \
	"Clone one of the logged in gh account's repos from github into the current folder (TUI/you pick)"
	fi
fi

