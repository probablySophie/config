__tmuxx_save_file="$HOME/.local/share/tmuxx/saved_session.json";

json="$(jq -r '.' $__tmuxx_save_file)";

# Pull a specific JSON variable from a given JSON object
function var { printf "$1" | jq -r ".$2"; }

function new_session
{
	session_json="$(printf "$json" | jq -r ".[$1]")";
	session_name="$(var "$session_json" "session_name")";
	tmux new-session -s "$session_name" -c "$(var "$session_json" "session_path")" -d
}

function new_window
{
	window_json="$(printf "$session_json" | jq -r ".windows.[$1]")";
	window_name="$(var "$window_json" "window_name")";

	# If we're the first window, just rename the pre-created one
	if [[ $1 == 0 ]]; then
		tmux rename-window -t "$session_name:0" "$window_name"
	else # Else make a new window
		tmux new-window -t "$session_name:" -n "$window_name";
	fi
}

function new_pane
{
	pane_json="$(printf "$window_json" | jq -r ".panes.[$1]")";
	pane_path="$(var "$pane_json" "pane_current_path")";

	tmux split-window -t "$session_name:$window_index" -c "$pane_path";
	if [[ $pane_index == 0 ]]; then
		tmux kill-pane -t "$session_name:$window_index.0";
	fi
	tmux resize-pane -t "$session_name:$window_index.$1" -y "$(var "$pane_json" "pane_height")"
}

# Each Session
session_index=0;
while [[ "$(printf "$json" | jq -r ".[$session_index]")" != "null" ]]; do

	new_session $session_index
	printf "Session: $session_name\n";

	# Each Window in the Session
	window_index=0;
	while [[ "$(printf "$session_json" | jq -r ".windows.[$window_index]")" != "null" ]]; do

		new_window $window_index
		printf "\t$window_index : $window_name\n";

		# Each Pane in the Window
		pane_index=0;
		while [[ "$(printf "$window_json" | jq -r ".panes.[$pane_index]")" != "null" ]]; do

			new_pane $pane_index
			printf "\t\t$pane_index @ $pane_path\n";

			pane_index=$(( pane_index + 1 ));
		done

		window_index=$(( window_index + 1 ));
	done

	session_index=$(( session_index + 1 ));
done

# If we only made one session - just attach to it
if [[ $session_index == 1 ]]; then
	tmux a;
else # There are multiple to choose from!
	# Open the session picker in the most recent session
	tmux choose-session;
	# Attach & view the session picker :)
	tmux a
fi
