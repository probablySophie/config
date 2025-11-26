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
descriptive_alias "todo1" \
	"grep -m 1 -r --exclude-dir='.*' --exclude-dir='node_modules' 'TODO:' *" \
	"Recursively list only the first instance of 'TODO:' per non-hidden file"

FZF_PREVIEW_FILES=" fzf -m --print0 --preview 'bat --color=always {}' --bind 'focus:transform-header:file --brief {}' "

# Does also escape other chars as I run into them
function escape_spaces { sed -e 's/ /\\ /g' -e 's/&/\\&/g' -e 's/(/\\(/g' -e 's/)/\\)/g' -e 's/\x0//g' ; }
custom_command "escape_spaces" "Escape spaces from the piped in input"

function open_in_editor { xargs --no-run-if-empty -0 -o ${EDITOR}; }

# https://github.com/junegunn/fzf
function fzf_preview_files {
	fzf -m --print0 --preview "bat --color=always {}" --bind "focus:transform-header:file --brief {}"
}

# Can we use RipGrep instead of grep?
# https://github.com/BurntSushi/ripgrep
if command -v rg &> /dev/null ; then
	function todoedit { rg -l "TODO:" | fzf_preview_files | escape_spaces | open_in_editor; }
else
	function todoedit { grep -rli --exclude-dir=".*" --exclude-dir="node_modules" --exclude-dir="dist" "TODO:" * | fzf_preview_files | escape_spaces | open_in_editor; }
fi
custom_command "todoedit" "Open an FZF window, pick 'TODO:' files, and open them in \$EDITOR"


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

descriptive_alias "hxo" "echo \"\$(<.helix/tabs.txt)\" | escape_spaces | xargs hx"

weather() { curl "https://wttr.in/$1?format=%l:+%C+%t+%x\nFeels+like+%f\nUV+index:+%u\nCurrent+Rain:+%p" ;}
custom_command "weather" "Get the current weather in \$1!"


# TUI clone one of my github repos
# Requres fzf for the TUI niceness & gh for the github part
if command -v fzf &> /dev/null ; then
	if command -v gh &> /dev/null ; then
		descriptive_alias "clone" "gh repo list -L 100"\
"| fzf "\
"| sed 's/[ \t].*//g' "\
"| xargs -I {} gh repo clone {} -- --recurse-submodules" \
	"Clone one of the logged in gh account's repos from github into the current folder (TUI/you pick)"
	# And submodules as well
		descriptive_alias "submodule" "gh repo list -L 100"\
"| fzf "\
"| sed 's/[ \t].*//g' "\
"| xargs -I {} git submodule add https://github.com/{}" \
	"Clone one of the logged in gh account's repos from github into the current folder (TUI/you pick)"
	fi
fi

# Pick a random todo/task item from a markdown file
function random_number
{
	printf "$((1 + $RANDOM % $1))"
}

custom_command "random_item" "Picks a random item/task from a given Markdown file."
function random_item
{
	local filename="$1";
	if [[ "$1" == "" ]]; then
		if [ -f "TODO.md" ]; then
			printf "No file given, using ./TODO.md\n";
			filename="TODO.md";
		else
			printf "No file given...\n";
			return
		fi
	fi

	local items=();

	while read line; do
		if [[ "$line" =~ ^\ ?[*-]\ \[\ \] ]]; then
			items+=("$line");
		fi
	done < "$filename"

	local count="${#items[@]}";
	local random_num="$(random_number "$count")";
	printf "Found $count todo items\n";
	printf "Item ${random_num}: "
	echo "${items[$(($random_num - 1))]}";

	# local i=1;
	# while [[ "$(cut )" != "" ]]; do
	# 	((i++));
	# 	printf "$i\n";
	# done
}
