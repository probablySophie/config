
__BASH_CONFIG_PATH="$HOME/.config/bash";

add_source ()
{
	if [[ -f "$__BASH_CONFIG_PATH/$1" ]]
	then
		source "$__BASH_CONFIG_PATH/$1"
	fi
}

add_source "about.sh"
add_source "alias.sh"
add_source "colours.sh"
add_source "tmux.sh"
add_source "welcome.sh"
add_source "git.sh"
add_source "completions.sh"
add_source "wsl.sh"
add_source "timezone.sh"
add_source "loading.sh"

# This one requires we have podman installed
if command -v podman &> /dev/null ; then
	add_source "podman_devcontainers.sh"
fi


# Make the timezone file if it doesn't exist.
if [[ ! -f "$HOME/.config/bash/timezone.sh" ]]; then
	printf "# Run `timedatectl list-timezones` to list all timezones\n"\
"# You can grep for your country/city to find your exact timezone\n"\
"TZ='UTC'" >> "$HOME/.config/bash/timezone.sh"
fi

# Add our local bin to the path
export PATH=~/.local/bin:$PATH
# Add our desktop files to the desktop files
export PATH=$HOME/.applications/desktop_files:$PATH

# ~ ~ ~ ~ SETTINGS ~ ~ ~ ~

bind -s 'set completion-ignore-case on' &> /dev/null

# Starship

if command -v starship &> /dev/null; then
	eval "$(starship init bash)"
else
	echo "${red}starship prompt not found${normal}"
fi

# Getting SSH to work with GPG

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# ~ ~ ~ ~ YAZI ~ ~ ~ ~
if command -v yazi &> /dev/null; then
	function y() {
		local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
		yazi "$@" --cwd-file="$tmp"
		if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
			builtin cd -- "$cwd"
		fi
		rm -f -- "$tmp"
	}
fi

# ~ ~ ~ ~ EXPORTS ~ ~ ~ ~

if command -v hx &> /dev/null; then
	export EDITOR="hx";
fi

# Nap is a loser & doesn't look in ~/.config by default???
if command -v nap &> /dev/null; then
	export NAP_CONFIG="$HOME/.config/nap/config.yaml"
	custom_command "nap" "The snippet manager we use"
fi

export XDG_CONFIG_HOME="$HOME/.config"
