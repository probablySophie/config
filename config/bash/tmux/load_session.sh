__tmuxx_save_file="$HOME/.local/share/tmuxx/saved_session.json";

json="$(jq -r '.' $__tmuxx_save_file)";

function var { printf "$1" | jq -r ".$2"; }

# Each Session
session_index=0;
while [[ "$(printf "$json" | jq -r ".[$session_index]")" != "null" ]]; do
	printf "$json" | jq -r ".[$session_index].session_name";
	session_json="$(printf "$json" | jq -r ".[$session_index]")";

	session_name="$(var "$session_json" "session_name")";

	tmux new-session -s "$session_name" -c "$(var "$session_json" "session_path")" -d

	# Each Window in the Session
	window_index=0;
	while [[ "$(printf "$session_json" | jq -r ".windows.[$window_index]")" != "null" ]]; do
		window_json="$(printf "$session_json" | jq -r ".windows.[$window_index]")";
		window_name="$(var "$window_json" "window_name")";

		tmux new-window -t "$session_name" -n "$window_name";
		if [[ $window_index == 0 ]]; then
			tmux kill-window -t "$session_name:0"
		fi

		printf "\t";
		printf "$session_json" | jq -r ".windows.[$window_index].window_name";

		# Each Pane in the Window
		pane_index=0;
		while [[ "$(printf "$window_json" | jq -r ".panes.[$pane_index]")" != "null" ]]; do
			pane_json="$(printf "$window_json" | jq -r ".panes.[$pane_index]")";

			tmux split-window -t "$session_name:$window_index" -c "$(var "$pane_json" "pane_path")";
			if [[ $pane_index == 0 ]]; then
				tmux kill-pane -t "$session_name:$window_index.0";
			fi
			tmux resize-pane -t "$session_name:$window_index.$pane_index" -y "$(var "$pane_json" "pane_height")"

			printf "\t\t";
			printf "$window_json" | jq -r ".panes.[$pane_index].pane_index";

			pane_index=$(( pane_index + 1 ));
		done

		window_index=$(( window_index + 1 ));
	done

	session_index=$(( session_index + 1 ));
done

function kill_temp
{
	local count=120;
	while true; do
		sleep 1;
		count=$(( count - 1 ));

		if [[ $count<=0 ]]; then break; fi
		# If the session doesn't exist at all, break
		if [[ "$(tmux list-sessions | grep "temp:")" == "" ]]; then break; fi

		# If we've detached from the temp session, kill it
		if [[ "$(tmux list-sessions | grep "temp:.*(attached)")" == "" ]]; then
			tmux kill-session -t "temp"
			break
		fi
	done
}

if [[ $session_index == 1 ]]; then
	tmux a;
else
	# Make a new "temp" session
	tmux new-session -s "temp" -d;
	# Tell the temp session to open the session picker
	tmux send-keys -t "temp" "tmux choose-session" Enter;
	# Queue up killing the temp session
	kill_temp &
	# Attach to the temp session 
	tmux a -t "temp"
fi
