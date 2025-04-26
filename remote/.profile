# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then # Are we running bash?
	if [ -f ~/.bashrc ]; then # If .bashrc exists
		. ~/.bashrc # Run it
	fi
fi

alias la='ls =A'

alias q="exit"	# because I use neovim and am dumb :(
alias :q="exit"
alias qq="exit"

# Case-insensitive tab completion
bind -s 'set completion-ignore-case on' &> /dev/null

# Use vim instead of vi, but only if we have vim installed
if command -v vim &> /dev/null; then
	alias vi="vim"
fi

# Vim Open - Open a given file in vim (in a seperate tmux instance)
function vo
{
	local FILE_NAME="$(printf "%s/%s/%s" "$PWD" "$(dirname $1)" "$(basename $1)")"
	local PANES=$(tmux list-panes -aF "#{pane_id} #{pane_current_command}");
	local VIM_PANES=$(echo "$PANES" | awk '/vi|vim|nvim/ {print $1}');
	tmux send-keys -t $VIM_PANES Escape ":tabnew ${FILE_NAME}" Enter;
}

# Not a clue what this does
mesg n 2> /dev/null || tru
