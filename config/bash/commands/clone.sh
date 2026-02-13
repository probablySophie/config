
# TUI clone one of my github repos
# Requres fzf for the TUI niceness & gh for the github part
custom_command "clone" "List repos belonging to the current 'gh' signed in account and clone the selected one"
function clone
{
	# Incase we forget to `git clone` and just tried to `clone`
	if [[ "$1" != "" ]]; then
		git clone "$1"
		return		
	fi
	# Else

	gh repo list -L 100 \
		| fzf \
		| sed 's/[ \t].*//g' \
		| xargs -r -I {} gh repo clone {} -- --recurse-submodules
}

# TODO: Submodule command?
