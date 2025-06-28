
function spinners
{
	if [ "$1" == "spiral"    ]; then printf "𜱼𜱽𜱾𜱿"; return; fi
	if [ "$1" == "explosion" ]; then printf "𜱩𜱪𜲉𜲊𜲋"; return; fi
	if [ "$1" == "stars"     ]; then printf "★✩✭✮✯✰✫✬"; return; fi
	if [ "$1" == "faces"     ]; then printf "☺☻"; return; fi
	if [ "$1" == "shapes"    ]; then printf "♥♦♣♠▲▼◆❖"; return; fi
	if [ "$1" == "braille1"  ]; then printf "⠁⠂⠄⡀⢀⠠⠐⠈"; return; fi
	if [ "$1" == "braille2"  ]; then printf "⠋⠇⡆⣄⣠⢰⠸⠙"; return; fi
	if [ "$1" == "dance"     ]; then printf "🯅🯆🯇🯆🯈🯆"; return; fi
}

# Call this function in the form
# "your command" & spinner "spinner name" $!
# e.g. 'sleep 5 & spinner "braille2" $!'
function spinner
{
	local PID=$2;
	local SPINNER_LOC=0;
	local SPINNER_NEXT=1;
	local SPINNER=$(spinners $1);
	local speed=0.2

	# Run kill without actually sending the kill signal
	# It returns true if its still alive
	while kill -0 $PID 2> /dev/null; do
		# echo -ne "\b\b${SPINNER:$SPINNER_LOC:$SPINNER_NEXT} ";
		echo -ne " ${SPINNER:$SPINNER_LOC:1}\033[0K\r"
		let SPINNER_LOC+=1;
		let SPINNER_NEXT+=1;
		# Clamp to our spinner array length
		if [ "${#SPINNER}" -eq "${SPINNER_LOC}" ]; then
			SPINNER_LOC=0
			SPINNER_NEXT=1
		fi
		sleep $speed # A little delay :)
	done
}

