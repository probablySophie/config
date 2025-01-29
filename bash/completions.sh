
#
# Completions & installing them if they don't exist (and are installable)
#

# Cargo completion :)

if [[ -f ~/.local/share/bash-completion/completions/rustup ]]; then
	# Do nothing, the completions are already installed :)
	printf "";
else
	# Make sure rustup is installed
	if command -v rustup &> /dev/null
		then
			# Do the thing
			mkdir -p ~/.local/share/bash-completion/completions
			rustup completions bash >> ~/.local/share/bash-completion/completions/rustup
			rustup completions bash cargo >> ~/.local/share/bash-completion/completions/cargo
		fi
fi


# Heavily based on https://julienharbulot.com/bash-completion-tutorial.html
# And with so much love to https://stackoverflow.com/a/11536437
__nap_complete() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return
	fi
	# Read the nap auto-completes into a list
	readarray -t nap_list <<< $(nap list)
	local items=()
	for item in "${nap_list[@]}"; do
		items+=($(printf "$item" | sed 's/ /\\\\\\ /g')" ");
	done

	local IFS=$'\n'
	local options=($(compgen -W "${items[*]}" "${COMP_WORDS[1]}"))

	if [[ "${#options[@]}" == "1" ]]; then
		local number=$(echo ${options[0]/%\ */})
	    COMPREPLY=("$number")
	else
		COMPREPLY=("${options[@]}")
		#readarray -t COMPREPLY <<< ${options[*]}
	fi
}
# __nap_complete
complete -F __nap_complete nap

