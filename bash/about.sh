
CUSTOM_COMMANDS=();
CUSTOM_COMMANDS_LEN=0;

CUSTOM_COMMANDS_ABOUT=();

alias ?='printf_about_command'


# A function that takes a command name & description
### $1 The command
### $2 The description
custom_command() 
{
	CUSTOM_COMMANDS+=("$1")
	CUSTOM_COMMANDS_ABOUT+=("$2")

	if [[ ${#1} -gt $CUSTOM_COMMANDS_LEN ]]; then
		CUSTOM_COMMANDS_LEN=${#1};
	fi	
}

printf_about_command()
{
	for ((i=0; i<${#CUSTOM_COMMANDS[@]}; i++)); do
		printf "\n\t ${blue}%-${CUSTOM_COMMANDS_LEN}s${normal} %s" "${CUSTOM_COMMANDS[$i]}" "${CUSTOM_COMMANDS_ABOUT[$i]}"
	done
	printf "\n"
}

