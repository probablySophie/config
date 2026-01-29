
# TODO: A friend in ~/.config/tmux/menus.conf that uses fzf to list sessions, pick one, and then call this

# TODO: Some form of session that takes a variable or opens an fzf window to select from a list e.g. list local code repos & open a specific set of windows/panes relative to the selected one

# Tmux management & stuff
# $1 - the json file to load sessions from
# $2 - the specific session to open


# INFO: Example valid JSON
# [
#     { "name": "Example", "dir": "~/Documents",
#         "windows": [
#             { "name": "Work", "dir": "~/Documents/Work" },
#             { "name": "Playground", "dir": "~/Code/playground", "active": true,
#                 "panes": [
#                     { "cmd": "ls", "name": "Guy" },
#                     { "height": "10", "split": "v" }
#                 ]
#             }
#         ]
#     },
# ]


JSON_FILE_PATH="$1";

function session_info
{
	if [[ $JSON_FILE_PATH != "" ]] && [[ -f "$JSON_FILE_PATH" ]]; then
		cat "$JSON_FILE_PATH";
		return
	fi
	cat "$HOME/.config/tmuxx/sessions.json"
}

OPEN_SESSION="";
if [[ "$2" != "" ]]; then
	OPEN_SESSION="$2";
fi

SESSION_i=0;
WINDOW_i=0;
PANE_i=0;

function session_var { session_info | jq -r ".[$SESSION_i].$1"; }
function window_var { session_info | jq -r ".[$SESSION_i].windows[$WINDOW_i].$1"; }
function pane_var { session_info | jq -r ".[$SESSION_i].windows[$WINDOW_i].panes[$PANE_i].$1"; }

function sanitize_path
{
	if [[ "$1" == "null" ]]; then printf ""; return; fi
	printf "${1/\~/$HOME}";
}

# $1 - session name
# $2 - session path - automatically replaces '~' with '$HOME'
function new_session { tmux new-session -s "$1" -c "$( sanitize_path "$2" )" -d; }

# $1 parent session name
# $2 window name
# $3 window directory
function new_window { tmux new-window -d -t "$1" -n "$2" -c "$( sanitize_path "$3" )"; }

function session_exists
{
	# List sessions, each session's name is on a new line
	if [[ "$(
		tmux list-sessions -F "#S" | while read line; do
			if [[ "$line" == "$1" ]]; then
				printf "true"
			fi
		done
		)" == "true" ]]; then
		return 0
	fi
	return 1
}


function handle_pane
{
	local WINDOW_TARGET="$(session_var "name"):$(window_var "name")";
	local PANE_TARGET="$((PANE_i - 1))";
	if [[ $PANE_TARGET -lt 0 ]]; then PANE_TARGET=0; fi

	local SPLIT="$(pane_var "split")";
	local DIR="$(sanitize_path $(pane_var "dir"))"

	# If we don't have a directory, use our parent's directory
	if [[ "$DIR" == "" ]] && [[ "$(sanitize_path "$(window_var "dir")")" != "" ]]; then
		DIR="$(sanitize_path "$(window_var "dir")")";
		if [[ "$DIR" == "" ]]; then
			DIR="$(sanitize_path "$(session_var "dir")")";
		fi
	fi

	tmux split-window -d -t "${WINDOW_TARGET}.$PANE_TARGET" "$(
		if [[ "$(printf "%.1s" "$SPLIT" | tr '[:upper:]' '[:lower:]')" == "h" ]]; then
			echo '-h';
		else
			echo '-v';
		fi
	)" -c "$DIR";

	if [[ $PANE_i == 0 ]]; then
		tmux kill-pane -t "${WINDOW_TARGET}.0";
	fi

	if [[ "$(pane_var "height")" != "null" ]]; then
		tmux resize-pane -t "${WINDOW_TARGET}.$PANE_i" -y "$(pane_var "height")"
	fi
	if [[ "$(pane_var "width")" != "null" ]]; then
		tmux resize-pane -t "${WINDOW_TARGET}.$PANE_i" -x "$(pane_var "width")"
	fi

	if [[ "$(pane_var "name")" != "null" ]]; then
		tmux select-pane -t "${WINDOW_TARGET}.$PANE_i" -T "$(pane_var "name")";
	fi

	if [[ "$(pane_var "cmd")" != "null" ]]; then
		tmux send-keys -t "${WINDOW_TARGET}.$PANE_i" "$(pane_var "cmd")" Enter
	fi
	printf "\t\t";
		session_info | jq -c -r ".[$SESSION_i].windows[$WINDOW_i].panes[$PANE_i]";
}

function handle_window
{
	new_window "$(session_var "name"):" "$(window_var "name")" "$(window_var "dir")";

	if [[ $WINDOW_i == 0 ]]; then
		# Kill what was the default/first window
		tmux kill-window -t "$(session_var "name"):0"
	fi

	if [[ "$( window_var "active" )" == "true" ]]; then
		tmux select-window -t "$(session_var "name"):$WINDOW_i";
	fi

	printf "\t$( window_var "name" ): $(window_var "dir")\n";

	# For each pane in the window
	while [[ "$( window_var "panes[$PANE_i]" )" != "null" ]]; do

		handle_pane

		PANE_i=$((PANE_i + 1));
	done
}

function handle_session
{
	if [[ "$OPEN_SESSION" != "" ]]; then
		if [[ "$(session_var "name")" != "$OPEN_SESSION" ]]; then
			return
		fi
	fi
	
	if session_exists "$( session_var "name" )"; then
		printf "Session '$(session_var "name")' appears to already exist\n";
		return;
	else
		new_session "$(session_var "name")" "$(session_var "dir")";
		printf "Session: $(session_var "name")\n";
	fi

	# For each window in the session
	while [[ "$( session_var "windows[$WINDOW_i]")" != "null" ]]; do
		PANE_i=0;

		handle_window

		WINDOW_i=$((WINDOW_i + 1));
	done
}

# For each session in the file
while [[ "$(session_info | jq ".[$SESSION_i]")" != "null" ]]; do
	WINDOW_i=0;

	handle_session
	
	SESSION_i=$((SESSION_i + 1));
done
