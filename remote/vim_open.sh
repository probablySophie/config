
# Vim Open
function vo
{
	local FILE_NAME="$(printf "%s/%s/%s" "$PWD" "$(dirname $1)" "$(basename $1)")"
	local PANES=$(tmux list-panes -aF "#{pane_id} #{pane_current_command}");
	local VIM_PANES=$(echo "$PANES" | awk '/vi|vim|nvim/ {print $1}');
	tmux send-keys -t $VIM_PANES Escape ":tabnew ${FILE_NAME}" Enter;
}
