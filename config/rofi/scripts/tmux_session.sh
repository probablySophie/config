# https://github.com/davatorium/rofi-scripts/blob/master/tmux_session.sh

function tmux_sessions()
{
    tmux list-session -F '#S'
}

TMUX_SESSION=$( (echo new; tmux_sessions) | rofi -dmenu -p "Select tmux session")

if [[ x"new" = x"${TMUX_SESSION}" ]]; then
    rofi-sensible-terminal -e tmux new-session &
elif [[ -z "${TMUX_SESSION}" ]]; then
    echo "Cancel"
else
    alacritty -e tmux attach -t "${TMUX_SESSION}" &
fi
