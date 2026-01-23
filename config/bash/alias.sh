#
#	Custom Alias Files
#

# Create an alias that runs a specific file, but ONLY if the file exists
# This is mostly for things like app images
safealias_file() # safealias_file FILEPATH COMMAND
{
	# If $1 exists as a file, alias safely for them
	if [ -f $1 ]; then alias $2="${1}"; fi
	# And create custom command descriptions with $3 if provided
	if [[ $3 ]]; then custom_command "$2" "$3"; fi
}

descriptive_alias()
{
	alias $1="${2}"
	if [[ $3 ]]; then custom_command "$1" "$3"; fi
}

# Create an alias that runs a specific command, but ONLY if the command exists
# Useful for overwriting default commands with funky drop-in replacements
safealias_command() # safealias_command COMMAND_TO_CHECK ALIAS
{
	# If the command $1 exists, alias $2 to $1
	if command -v $1 &> /dev/null ; then alias $2="${1}"; fi
	# If $3 exists, add it as a description to `?`
	if [[ $3 ]]; then custom_command "$2" "$3"; fi
}

safealias_file $HOME/AppImages/love*.AppImage love "Run Love2D" # Love2D :)

custom_command "todo" "Recirsively get and list all instances of 'TODO:' in files in \$PWD"
function todo
{
	if command -v rg &> /dev/null; then rg "TODO:" --trim --max-columns=150;
	else grep -r --exclude-dir='.*' --exclude-dir='node_modules' 'TODO:' *
	fi
}

custom_command "todo1" "Recirsively get and list the first instance of 'TODO:' in files in \$PWD"
function todo1
{
	if command -v rg &> /dev/null; then rg "TODO:" --trim --max-columns=150 -m 1;
	else grep -m 1 -r --exclude-dir='.*' --exclude-dir='node_modules' 'TODO:' *
	fi
}

# Does also escape other chars as I run into them
function escape_spaces { sed -e 's/ /\\ /g' -e 's/&/\\&/g' -e 's/(/\\(/g' -e 's/)/\\)/g' -e 's/\x0//g' ; }
custom_command "escape_spaces" "Escape spaces (and other rude chars) from the piped in input"

# Open the piped values in the editor (but only if there ARE piped values)
function open_in_editor { xargs --no-run-if-empty -0 -o ${EDITOR}; }

# https://github.com/junegunn/fzf
function fzf_preview_files {

	# Rename the little 'header' above the search box to be info about the current file
	local FZF_FOCUS_RENAME="focus:transform-header:file --brief {}";

	local FZF_PREVIEW='cat {}';
	if [[ -f "$HOME/.config/bash/commands/preview_file.sh" ]]; then
		# Use our fancy viewer if available
		FZF_PREVIEW='. ~/.config/bash/commands/preview_file.sh {} $FZF_PREVIEW_LINES $FZF_PREVIEW_COLUMNS';
	elif command -v bat &> /dev/null; then
		# Use bat as a fallback if available
		FZF_PREVIEW="bat --color=always {}";
	fi

	# On start and resize, if the ratio is < 2.5 then preview top, else preview right
	local FZF_RESIZE_PREVIEW_TRANSFORMER='start,resize:transform:if [[ $(( $FZF_COLUMNS / $FZF_LINES )) < 2.5 ]]; then echo "change-preview-window:up"; else echo "change-preview-window:right"; fi'

	fzf \
		-m \
		--print0 \
		--preview "$FZF_PREVIEW" \
		--preview-window right,1,border-horizontal,50% \
		--bind "${FZF_FOCUS_RENAME}" \
		--bind "${FZF_RESIZE_PREVIEW_TRANSFORMER}"
}

# Can we use RipGrep instead of grep?
# https://github.com/BurntSushi/ripgrep
if command -v rg &> /dev/null ; then
	function todoedit { rg -l "TODO:" | fzf_preview_files | escape_spaces | open_in_editor; }
else
	function todoedit { grep -rli --exclude-dir=".*" --exclude-dir="node_modules" --exclude-dir="dist" "TODO:" * | fzf_preview_files | escape_spaces | open_in_editor; }
fi
custom_command "todoedit" "Open an FZF window, pick 'TODO:' files, and open them in \$EDITOR"

function todofile { fzf_preview_files "TODO.md" | escape_spaces | open_in_editor; }
custom_command "todofile" "Open an FZF window, pick files named 'TODO.md' and open then in \$EDITOR"

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
fi

descriptive_alias 'pysource' "source .venv/bin/activate" "Source .venv/bin/active (for python)"

# descriptive_alias 'llama' "docker exec -it ollama ollama run llama3" "Run llama3 using ollama"
# descriptive_alias 'codellama' "docker exec -it ollama ollama run codellama" "Run codellama using ollama"

# ~ ~ ~ ~ CUSTOM COMMANDS ~ ~ ~ ~

_mkd() { mkdir -p $1; cd $1; } # Make a directory and cd into it
descriptive_alias "mkd" "_mkd" "Make a new directory and CD into it"

descriptive_alias "hxo" "echo \"\$(<.helix/tabs.txt)\" | escape_spaces | xargs -r hx"

weather() { curl "https://wttr.in/$1?format=%l:+%C+%t+%x\nFeels+like+%f\nUV+index:+%u\nCurrent+Rain:+%p" ;}
custom_command "weather" "Get the current weather in \$1!"

# Custom clone command to clone github repos
add_source "commands/clone.sh";

# Pick a random todo/task item from a markdown file
function random_number { printf "$((1 + $RANDOM % $1))"; }

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

	local line_nums=();
	local items=();

	local line_num=0;
	while read line; do
		_=$((line_num++));
		if [[ "$line" =~ ^\ ?[*-]\ \[\ \] ]]; then
			items+=("$line");
			line_nums+=($line_num);
		fi
	done < "$filename"

	local count="${#items[@]}";
	local random_num="$(random_number "$count")";
	printf "Found $count todo items\n";
	printf "Item ${random_num}: \n";
	echo "${items[$(($random_num - 1))]}";

	printf "\nWould you like to open that in Helix? (y/N)\n";
	read -n1 ans;
	if [[ "$ans" =~ ^[yY] ]]; then
		hx "${filename}":"${line_nums[$(($random_num - 1))]}";
	fi
}
