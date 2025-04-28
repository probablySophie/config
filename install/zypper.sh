# Install stuff that we use & need from zypper
# For SUSE & OpenSUSE linux distros

if command -v zypper &> /dev/null ; then
	CMD=(
		sudo zypper in -y
		fzf # TUI Fuzzy finder & selector
		tmux # TMUX!
		make gcc cmake # friends for installing & building software
		libnotify-tools # For commandline notifications
		podman # Container management
		jq # For cli/bash json parsing
		file # for Yazi
	)
	"${CMD[@]}"
fi

notify-send "Finished Installing!" -a "zypper.sh"
