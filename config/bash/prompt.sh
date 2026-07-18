# TODO: Path
# TODO: are we a user or su?
# TODO: Localhost vs remote

# INFO: This is very heavily influenced by nix-prompt
# https://github.com/nix-tricks/nix-prompt

# INFO: Prompt variables can be played with here:
# https://neikiri.dev/bash-prompt-generator/
command_exists() { if command -v $1 > /dev/null 2>&1; then return 0; else return 1; fi }

git_folder() {
	if ! command_exists git; then return 1; fi
	git_root="$(git rev-parse --show-toplevel 2>/dev/null)";
	printf "%s" "${git_root##*/}";
}
print_git_repo() {
	if [[ "$(git_folder)" == "" ]]; then return 1; fi
	printf "\033[36m" # Colour
	printf "$(git_folder)"
	if [[ ! -z "$(git status -s 2>/dev/null)" ]]; then printf " [+]"; fi
	printf "\033[39m"; # Colour reset
	branch="$(print_git_branch)"
	if [[ -n "$branch" ]]; then printf " %s" "$branch"; fi
	printf " "
}
print_git_branch()
{
	# The branch (if different)
	git_branch="$(git branch -q --show-current 2>/dev/null)";
	if [[ "${git_branch}" != "" && "${git_branch}" != "main" && "${git_branch}" != "master" ]]; then
		printf "%s" "$git_branch"
	fi
}

is_root() { [[ $EUID -eq 0 ]]; }

printable_path() {
	if [[ "$(git_folder)" == "" ]]; then printf "${PWD/$HOME/'~'}"; return 0; fi
	local git_path="$(git rev-parse --show-toplevel 2>/dev/null)";
	printf "${PWD/$git_path/'...'}"
}

PS1='';
PS1+="\$(print_git_repo)"
# PS1='\D{%Y-%m-%d}' # Date
PS1+='\D{%I:%M%P}' # Time
#PS1+=" ${PWD/$HOME/'~'} "
PS1+=" \033[35m\$(printable_path)\033[39m"

PS1+='\n'
PS1+='\033[37m$ \033[39;49m'
# PS1+='\u' # Username
# PS1+='\#' # Root indicator?
# PS1+='\h' # Hostname (short)
# PS1+='\H' # Hostname (long)

# '\w' # Full PWD path
# '\W' # current folder name

# '\${SSH_CONNECTION:+ssh}' # is currently an ssh connection



