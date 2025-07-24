
. "$__BASH_CONFIG_PATH/tmux/util_functions.sh";
__tmuxx_save_file="$HOME/.local/share/tmuxx/saved_session.json";

# Trying to save the tmux windows

json="[]";

# ID, Name, Path, num windows
sessions=$(tmux list-sessions -F "#{session_id}|#S|#{session_path}|#{session_windows}");
function handle_sessions
{
	count=$( count_num "$sessions" );
	# Handle the sessions!
	for (( i=0; i<$count; i++ )); do
		session="$( get_line "$sessions" $i )";
		printf "Session: $session\n";

		json="$(echo "$json" | jq '. += [{
				"id": "'$( get_field "$session" 1 | sed 's/\$//g' )'",
				"name": "'"$( get_field "$session" 2 )"'",
				"path": "'"$( get_field "$session" 3 )"'",
				"windows": []
			}]')";
	done
}

windows=$(tmux list-windows -F "#{session_id}|#{window_id}|#{window_name}|#{window_index}|#{window_panes}");
function handle_windows
{
	count=$( count_num "$windows" );
	# Handle the windows!
	for (( i=0; i<$count; i++ )); do
		window="$( get_line "$windows" $i )";
		printf "\tWindow: $window\n";
		session_id=$( get_field "$window" 1 | sed 's/\$//g' );
		session_num=$(echo "$json" | jq "map(.id==\""$session_id"\")| index(true)");

		json="$(echo "$json" | jq '.['$session_num'].windows += [ {
				"id": "'"$( get_field "$window" 2 | sed 's/\@//g' )"'",
				"name": "'"$( get_field "$window" 3 )"'",
				"index": "'"$( get_field "$window" 4 )"'",
				"panes": []
			} ]')";
	done
}

# panes=$(tmux list-panes -F );
panes=$(tmux list-panes -s -F "#{session_id}|#{window_id}|#{pane_index}|#{pane_current_path}|#{pane_title}|#{pane_width}|#{pane_height}");
function handle_panes
{
	count=$( count_num "$panes" );
	# Handle the panes!
	for (( i=0; i<$count; i++ )); do
		pane="$( get_line "$panes" $i )";
		session_id=$( get_field "$pane" 1 | sed 's/\$//g' );
		session_num=$(echo "$json" | jq "map(.id==\""$session_id"\")| index(true)");
		window_id=$( get_field "$pane" 2 | sed 's/\@//g' );
		window_num=$(echo "$json" | jq ".[$session_num].windows | map(.id==\""$window_id"\")| index(true)");

		# printf "session: ${session_num} window: ${window_num}\n";

		json="$(echo "$json" | jq '.['$session_num'].windows['$window_num'].panes += [ {
				"name": "'"$( get_field "$pane" 5 )"'",
				"index": "'"$( get_field "$pane" 3 )"'",
				"path": "'"$( get_field "$pane" 4 )"'",
				"width": "'"$( get_field "$pane" 6 )"'",
				"height": "'"$( get_field "$pane" 7 )"'"
			} ]')";
	done
}

handle_sessions;
handle_windows;
handle_panes;

mkdir -p ~/.local/share/tmuxx
echo "$json" > "$__tmuxx_save_file";
printf "Saved to $__tmuxx_save_file";
