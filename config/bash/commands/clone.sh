
# TUI clone one of my github repos
# Requres fzf for the TUI niceness & gh for the github part
custom_command "clone" "List repos belonging to the current 'gh' signed in account and clone the selected one"
function clone
{
	if [[ "$1" == "" ]]; then
		gh repo list -L 100 \
			| fzf \
			| sed 's/[ \t].*//g' \
			| xargs -r -I {} gh repo clone {} -- --recurse-submodules
		return
	fi
	# Incase we forget to `git clone` and just tried to `clone`
	git clone "$1"
}

# TODO: Submodule command?
