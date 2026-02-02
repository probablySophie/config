# A test Rofi script for running other scripts

# Examples
# https://github.com/davatorium/rofi-scripts

# Arch Linux Man Page
# https://man.archlinux.org/man/rofi-script.5.en

ROFI_CONFIG_PATH="$HOME/.config/rofi";

function rofi_scripts()
{
	ls "${ROFI_CONFIG_PATH}/scripts"
	if [[ -d "$HOME/.local/rofi_scripts" ]]; then
		ls "$HOME/.local/rofi_scripts"
	fi
}
function run_rofi_scripts_selection()
{
	if [[ "$1" == "" ]]; then
		if [[ "$2" != true ]]; then
			printf "No selection\n";
		fi
		return
	fi
	# There was a selection - run it
	if [[ "$2" != true ]]; then
		printf "You selected $1\n";
		. "${ROFI_CONFIG_PATH}/scripts/$1";
	else
		# notify-send "Running ${ROFI_CONFIG_PATH}/scripts/$1";
		ROFI_RETV=""; # Clear RETV so the script runs as new

		if [[ -f "${ROFI_CONFIG_PATH}/scripts/$1" ]]; then
			bash -e "${ROFI_CONFIG_PATH}/scripts/$1";
		elif [[ -f "${HOME}/.local/rofi_scripts/$1" ]]; then
			bash -e "${HOME}/.local/rofi_scripts/$1";
		fi
	fi
}
function run_rofi_scripts()
{
	local SCRIPT_SELECTION=$( rofi_scripts | rofi -dmenu run -p "Select a script" -theme "${ROFI_CONFIG_PATH}/styles/test.rasi" );
	run_rofi_scripts_selection "$SCRIPT_SELECTION";
}
# Pipe all scripts in the rofi script file folder into rofi

# We've been run fresh (outside of Rofi)
if [[ "$ROFI_RETV" == "" ]]; then
	run_rofi_scripts;
	return
fi

# We've been asked by Rofi what our options are
if [[ "$ROFI_RETV" == 0 ]]; then
	rofi_scripts
	exit
fi
# Something was selected! ($@ contains the selection)
if [[ "$ROFI_RETV" == 1 ]]; then
	coproc ( run_rofi_scripts_selection "$@" true > /dev/null 2>&1 )
fi

# No selection?  Exit

