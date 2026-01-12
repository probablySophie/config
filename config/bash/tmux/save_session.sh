__tmuxx_save_file="$HOME/.local/share/tmuxx/saved_session.json";
mkdir -p "$HOME/.local/share/tmuxx";

# All the values that we want to query. They're stored in a JSON object as "value_name": "value_value"
session_values=("session_id" "session_name" "session_path" "session_windows");
window_values=("window_id" "window_name" "window_index" "window_panes");
pane_values=("pane_index" "pane_current_path" "pane_title" "pane_width" "pane_height");

function json_tmux_query
{
	local array=("$@");
	local query_string="";
	for item in "${array[@]}"; do
		query_string="${query_string} \"$item\": \"#{$item}\","
	done
	# Trim the final comma
	query_string="${query_string::-1}"
	printf "$query_string";
}
# Build the one giant query
pane_query="{$(json_tmux_query "${pane_values[@]}") #}#,";
window_query="{$(json_tmux_query "${window_values[@]}"), \"panes\": [#{P:#{$pane_query}}] #}#,";
session_query="{$(json_tmux_query "${session_values[@]}"), \"windows\": [#{W:#{$window_query}}] #}#,";

# Do the display-message query
result="$(tmux display-message -p "[#{S:#{$session_query}}]")";
# Replace all ,] with ] so JQ won't freak out
result="$(printf "$result" | sed 's/,]/]/g')";

# Save the results
printf "$result" | jq -r '.' > $__tmuxx_save_file;
