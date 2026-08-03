# Cat icon was uncredited, gotten from https://www.asciiart.eu/animals/cats

plural() {
	if [[ ${1} -ne 1 ]]; then
		printf "s"
	fi
}

UPTIME_STRING="";
# Not all systems have /proc/uptime
if [[ -f /proc/uptime ]]; then
	uptime=$(cat /proc/uptime | cut -d ' ' -f 1) # get the uptime
	uptime=${uptime%.*} # float -> int

	uptime_days=$((uptime/86400))			# how many days
	uptime=$((uptime%86400))				# remove the days

	uptime_hours=$((uptime/3600))			# how many hours
	uptime=$((uptime%3600))					# remove the hours

	uptime_minutes=$((uptime/60))
	uptime_seconds=$((uptime%60))

	UPTIME_STRING+="$(printf "Uptime: ${purple}${uptime_days}${normal} day"	)"
	UPTIME_STRING+="$(plural $uptime_days)"
	UPTIME_STRING+="$(printf " ${purple}${uptime_hours}${normal} hour"		)"
	UPTIME_STRING+="$(plural $uptime_hours)"
	UPTIME_STRING+="$(printf " ${purple}${uptime_minutes}${normal} minute"	)"
	UPTIME_STRING+="$(plural $uptime_minutes)"
	UPTIME_STRING+="$(printf " ${purple}${uptime_seconds}${normal} second"	)"
	UPTIME_STRING+="$(plural $uptime_seconds)"
fi
# if command -v uptime &> /dev/null; then
# 	UPTIME_STRING="$(uptime \
# 		| awk '{
# 		str=$0;
# 		# Remove the current time & "up"
# 		sub(/^\s*[0-9]+:[0-9]+:[0-9]+\s+up\s+/,"",str);
# 		sub(/,\s*[0-9]+\s*user.*$/,"",str);
# 		patsplit(str, a, /[0-9]+/);

# 		if ( length(a) == 3 ) { days=a[1]; hours=a[2]; mins=a[3]; }
# 		else { days=0; hours=a[1]; mins=a[2]; }

# 		if ( days > 0 ) { printf days; printf " day"; if ( days > 1 ) { printf "s" } printf " " }

# 		if ( hours > 0 ) { printf hours; printf " hour"; if ( hours > 1 ) { printf "s" } printf " " }
	
	
# 		if ( mins > 0 ) { printf mins; printf " min" }
# 		if ( mins > 1 ) { printf "s" }
# 	}");
# fi

shell_name="";
if [[ "$SHELL" == "" ]]; then
	shell_name=$(ps | grep $(echo $$) | rev | cut -d ' ' -f 1 | rev);
else
	shell_name="$SHELL";
fi

printf "%b" "${purple}${shell_name}${normal} is running in ${purple}${TERM}${normal} (${purple}${HOSTTYPE}${normal} os)\n"

printf " /\_/\  "
printf "$UPTIME_STRING"

printf "\n( o.o ) It is ${purple}%(%F)T${normal}.${purple} %(%R)T${normal} local time\n" -1 -1

printf " > ^ <  User: ${purple}${USER}${normal}@${purple}$(hostname)${normal}\n" 
# printf "IP: ${purple}$(hostname -I | cut -d' ' -f1)${normal}\n"

printf " ${red}E"
printf "${orange}n"
printf "${yellow}j"
printf "${green}o"
printf "${blue}y"
printf "${purple}!${normal}"

char_array=(
	"◯ " "■ " "▢ " "▪ " "▬ " "▲ " "▶ " "◀ " "◆ " "<3" 
	"● " "◼ " "★ " "♙ " "✈ " "♥ " "✉ " "✒ " "✎ " "✪ " 
	"☀ " "☁ " "☂ " "☢ " "☮ " "☻ " "♀ " "♫ " "♦ " "☎  "
	"♻ " "⚑ " "⚔ " "⚢ " "⚥ " "⬟ " "⬢ " "⬣ " "⮕ " 
)

rainbow "${char_array[(RANDOM % ${#char_array[@]} + 1)-1]}"

unset plural		# cleaning up
unset uptime
unset uptime_days
unset uptime_minutes
unset uptime_hours
unset uptime_minutes
unset uptime_seconds
unset char_array

#
# Welcome to SHELL_NAME
# Running in TERMINAL_EMULATOR_NAME
#
# The local time is $TIME	\D{format}	\@
# The local date is $DATE	\d
#
# Run $COMMAND to open your splash screen
#
#
#
#	As per https://phoenixnap.com/kb/change-bash-prompt-linux
#
# \a – A bell character
# \h – Hostname (short)
# \j – Number of jobs being managed by the shell
# \l – The basename of the shells terminal device
# \n – New line
# \s – The name of the shell
# \@ – Time, 12-hour AM/PM
# \u – Current username
# \v – BASH version
# \w – Current working directory ($HOME is represented by ~)
# \$ – Specifies whether the user is root (#) or otherwise ($)
#
# \[ – Start a sequence of non-displayed characters (useful if you want to add a command or instruction set to the prompt)
# \] – Close or end a sequence of non-displayed characters
