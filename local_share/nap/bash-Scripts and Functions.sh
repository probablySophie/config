# Get the path a script was called with
path="${0%/*}"

# Are we in a TMUX session
if [[ -n "$TMUX" ]]; then
	printf "We're in a TMUX session";
else
	printf "We aren't in a TMUX session";
fi

# Get files from a programatic path
path="${0%/*}"    # Get the path a script was called with
files=("$path"/*) # Get all files from that path

# Testing your logic in the bash prompt
[[ $logic == $example ]] && printf "Prints if true" || printf "Prints if false"

# Read into $input
read input
[[ $input == y* ]] # Does our input start with 'y'?
