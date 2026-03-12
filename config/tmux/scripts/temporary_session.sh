# Using && so we know that the command has finished executing before the next one runs
SESSION_NAME="$1";  if [[ "$SESSION_NAME" == "" ]]; then SESSION_NAME="temp_session"; fi
RUN_COMMAND="$2";
CURRENT_SESSION="$(tmux display-message -p "#S")";

tmux new-session -c "$(tmux display-message -p "#{pane_current_path}")" -d -s "$SESSION_NAME" \
	&& tmux send-keys -t "$SESSION_NAME" "$RUN_COMMAND; tmux switch-client -t '$CURRENT_SESSION' && tmux kill-session" ENTER \
	&& tmux switch-client -t "$SESSION_NAME";
