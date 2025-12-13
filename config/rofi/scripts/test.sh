# A test Rofi script

# Examples
# https://github.com/davatorium/rofi-scripts

ROFI_CONFIG_PATH="$HOME/.config/rofi";

function rofi_scripts()
{
	ls "${ROFI_CONFIG_PATH}/scripts"
}
# Pipe all scripts in the rofi script file folder into rofi
SCRIPT_SELECTION=$( rofi_scripts | rofi -dmenu run -p "Select a script" -theme "${ROFI_CONFIG_PATH}/styles/test.rasi" )

# No selection?  Exit
if [[ "${SCRIPT_SELECTION}" == "" ]]; then
	printf "No selection\n";
	return
fi
# There was a selection - run it
printf "You selected ${SCRIPT_SELECTION}\n";
. "${ROFI_CONFIG_PATH}/scripts/${SCRIPT_SELECTION}";

