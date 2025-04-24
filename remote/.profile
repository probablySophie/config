# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

alias la='ls =A'

alias q="exit"	# because I use neovim and am dumb :(
alias :q="exit"
alias qq="exit"

bind -s 'set completion-ignore-case on' &> /dev/null

# Use vim instead of vi, but only if we have vim installed
if command -v vim &> /dev/null; then
	alias vi="vim"
fi
# Vim Open
function vo
{
	local FILE_NAME="$(printf "%s/%s/%s" "$PWD" "$(dirname $1)" "$(basename $1)")"
	local PANES=$(tmux list-panes -aF "#{pane_id} #{pane_current_command}");
	local VIM_PANES=$(echo "$PANES" | awk '/vi|vim|nvim/ {print $1}');
	tmux send-keys -t $VIM_PANES Escape ":tabnew ${FILE_NAME}" Enter;
}



mesg n 2> /dev/null || tru
