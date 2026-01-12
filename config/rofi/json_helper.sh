# Logic & stuff stolen from https://github.com/luiscrjunior/rofi-json

function json_read
{
	# printf "File exists!\n";
	FILE_CONTENTS="$(cat $1)";

	echo $FILE_CONTENTS \
		| jq -cr '.[] | "\(.name)|\(.command)|\(.icon)"' \
		| while IFS="|" read -r name command icon
		do
			if [[ $name == "null" ]]; then
				continue
			fi        
			if [[ $icon == "null" ]]; then
				icon="system-run"
			fi      
				echo -en "${name}\0icon\x1f${icon}\n"
			done
}

function do_the_thing
{
	if [[ "$1" == "" ]]; then
		printf "No arguments provided\n";
		return
	fi
	if [[ ! -f "$1" ]]; then
		printf "Provided argument does not appear to be a file\n";
		return
	fi

	# Get a selection from the user
	SELECTION=$( json_read "$1" | rofi -dmenu -show-icons)

	if [[ "$SELECTION" == "" ]]; then
		printf "No selection made\n";
		return
	fi
	printf "$SELECTION\n";
	
	FILE_CONTENTS="$(cat $1)";

	# Get the item that matches our selection & dangerously eval it
	echo $FILE_CONTENTS \
		| jq -cr ".[] | select(.name == \"${SELECTION}\") | \"\(.name)|\(.command)|\(.icon)\"" \
			| while IFS="|" read -r name command icon
			do
				if [[ "$command" == "null" ]]; then
					eval "$name";
				else
					eval "$command";
				fi
			done
}

do_the_thing "$1"

