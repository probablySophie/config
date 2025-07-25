
. "$__BASH_CONFIG_PATH/tmux/util_functions.sh";
__tmuxx_save_file="$HOME/.local/share/tmuxx/saved_session.json";


if [[ ! -f $__tmuxx_save_file ]]; then
	printf "No saved session found\n";
	return
fi

# local pane_name="$()";

# $1 is the session_index
function make_session
{
	local name="$(session_info $1 "name" )";
	local path="$(session_info $1 "path" )";

	tmux new-session -c "$path" -s "$name" -d;
	# Make a new session
	# tmux new-session -c "directory" -s "session_name" -d
	# -n names the first window. Use...?
}
# $1 is the session_index
# $2 is the number of windows
function make_windows
{
	local session_index="$1";
	local session_name="$(session_info $1 "name" )";

	local i=0;
	for (( i=0; i<$2; i++ )); do
		local window_index="$(jq -r '.['$1'].windows | map(.index == "'$i'") | index(true)' $__tmuxx_save_file)";
		
		local pane_1_path="$(pane_info $1 $window_index 0 "path" )";
		local window_name="$(window_info $1 $window_index "name" )";
	
		tmux new-window -a \
			-t "$session_name" \
			-n "$window_name" \
			-c "$pane_1_path"
		tmux select-window -t "$session_name:$(( $window_index + 1 ))"
	done
	# And then close the first window we made
	tmux kill-window -t "${session_name}:0";
}

function handle_sessions
{
	# Get our saved session IDs
	session_ids=$(jq -r '.[].id' $__tmuxx_save_file);
	num_sessions=$(count_num "$session_ids");

	# printf "Found $num_sessions saved session(s)!\n";
	local i=0;
	for (( i=0; i<${num_sessions}; i++ )); do
		local session_id=$( get_line "${session_ids}" $i );
		local session_index=$(jq 'map(.id == "'$session_id'") | index(true)' $__tmuxx_save_file);
		# printf "Session id: $session_id\n";
		make_session $session_index;
		handle_windows $session_index;
	done
}

# Get Windows from the sesions
# $1 is the session index
function handle_windows
{
	local session_index=${1};

	# and get the window IDs for that session
	local window_ids=$(jq -r '.['$session_index'].windows.[].id' $__tmuxx_save_file);
	local num_windows=$(count_num "$window_ids");

	make_windows $session_index $num_windows

	local i=0;
	for (( i=0; i<${num_windows}; i++ )); do
		local window_id=$( get_line "${window_ids}" $i );
		local window_index=$(jq '.['$session_index'].windows | map(.id == "'$window_id'") | index(true)' $__tmuxx_save_file);

		# printf "\tWindow id: $window_id\n";

		get_panes $session_index $window_index;
	done
}

# $1 is the session index
# $2 is the window index
function get_panes
{
	local session_index=${1};
	local window_index=${2};
	
	local session_name="$(session_info $1 "name" )";
	local window_name="$(window_info $session_index $window_index "name" )";
	
	local pane_indexes=$(jq -r '.['$session_index'].windows.['$window_index'].panes.[].index' $__tmuxx_save_file);
	local num_panes=$(count_num "$pane_indexes");

	# jq -r '.['$session_index'].windows.['$window_index'].panes' $__tmuxx_save_file;
	local i=0;
	for (( i=1; i<${num_panes}; i++ )); do	
		local pane_index=$(jq ".[$session_index].windows.[$window_index].panes | map(.index == \"$i\") | index(true)" $__tmuxx_save_file);
		local pane_path="$(pane_info $session_index $window_index $pane_index "path")";

		tmux split-window -t "$session_name:$window_name" -c "$pane_path"
	done
	# And kill the first pane that already existed
	# tmux kill-pane -t "${session_name}:${window_name}.0"

	# And then rename & such?
	for (( i=0; i<${num_panes}; i++ )); do	
		local pane_index=$(jq ".[$session_index].windows.[$window_index].panes | map(.index == \"$i\") | index(true)" $__tmuxx_save_file);
		local pane_width="$(pane_info $session_index $window_index $pane_index "width")";
		local pane_height="$(pane_info $session_index $window_index $pane_index "height")";
		local pane_name="$(pane_info $session_index $window_index $pane_index "name")";

		tmux resize-pane -t "${session_name}:${window_name}.${pane_index}" -x $pane_width -y $pane_height
		
	done
}

handle_sessions

function kill_temp
{
	local count=120;
	while true; do
		sleep 1;
		_=$(( count-- ));

		if [[ $count<=0 ]]; then
			break;
		fi
		
		# If the session doesn't exist at all, break
		if [[ "$(tmux list-sessions | grep "temp:")" == "" ]]; then
			break;
		fi

		# If we've detached from the temp session, break
		if [[ "$(tmux list-sessions | grep "temp:.*(attached)")" == "" ]]; then
			tmux kill-session -t "temp"
			break
		fi
	done
}

# If there's only one session - just attach to that
if [[ "$(tmux list-session | wc -l)" == "1" ]]; then
	tmux a
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
