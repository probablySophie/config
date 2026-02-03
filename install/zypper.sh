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
		man-pages # Man Pages
		gh # Github's CLI
	# Bits for basic containers
		git
		unzip
		wget curl
		hostname
	)
	"${CMD[@]}"
fi

sudo zypper in -t pattern devel_C_C++

# No WSL Notifications thanks
if [[ ! -d "/mnt/c/Program Files/" ]]; then
	notify-send "Finished Installing!" -a "zypper.sh"
fi
