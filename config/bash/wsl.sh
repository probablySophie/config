
# ~ ~ ~ ~ Windows Subsystem for Linux ~ ~ ~ ~

# Check if there is a windows mount
if [[ -d "/mnt/c/Program Files/" ]]; then
	# If yes, it's probably WSL
	printf "This appears to be a Windows Subsystem for Linux terminal instance.\n";
else
	return
fi

# Make sure there's a tmux temp directory
export TMUX_TMPDIR='/tmp'

# WSL doesn't properly report directories ._.
tmux set-option -g default-terminal 'xterm-256color'


export BROWSER="wslview" # This stops issues with `gh auth login`
