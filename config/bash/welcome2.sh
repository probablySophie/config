# https://codeberg.org/Lunar267/fish_cute-greeting

function set_colour
{
	if [[ "$1" == "reset" ]]; then printf "\e[0m"; return
	elif [[ "$1" == "black" ]]; then printf "\e[1;30m"; return
	elif [[ "$1" == "red" ]]; then printf "\e[1;31m"; return
	elif [[ "$1" == "green" ]]; then printf "\e[1;32m"; return
	elif [[ "$1" == "yellow" ]]; then printf "\e[1;33m"; return
	elif [[ "$1" == "blue" ]]; then printf "\e[1;34m"; return
	elif [[ "$1" == "magenta" ]]; then printf "\e[1;35m"; return
	elif [[ "$1" == "cyan" ]]; then printf "\e[1;36m"; return
	elif [[ "$1" == "white" ]]; then printf "\e[1;37m"; return
	elif [[ "$1" == "orange" ]]; then printf "$(tput setaf 208)"; return
	fi
}

for i in $(seq 30 37); do printf "\e[1;${i}m█"; done
for i in $(seq 40 47); do printf "\e[1;${i}m "; done
printf "$(set_colour reset)\n";
for i in $(seq 90 97); do printf "\e[1;${i}m█"; done
for i in $(seq 100 107); do printf "\e[1;${i}m "; done
printf "$(set_colour reset)\n";

for i in $(seq 1 231); do
	printf "\e[38:5:${i}m"; printf "$i ";
	if [[ "${#i}" == 1 ]]; then printf "  "; fi
	if [[ "${#i}" == 2 ]]; then printf " "; fi
	if [[ $(( $i % 20 )) == 0 ]]; then printf "\n"; fi
done
printf "$(set_colour reset)\n";


printf "$(set_colour green)%s$(set_colour reset)@$(set_colour yellow)%s$(set_colour reset)" "$(whoami)" "$(hostname)"

printf "$(set_colour reset)\n";

printf "Running on "
awk -F'"' '/PRETTY_NAME/ {print $2}' /etc/os-release

printf "$(set_colour blue)Memory \t$(set_colour orange)-$(set_colour reset) ";
free -h | awk '/Mem:/ { print $3" / "$2 }';
# printf "\n";

printf "$(set_colour blue)CPU \t$(set_colour orange)-$(set_colour reset) ";
awk '/cpu cores/{c=1} c{ printf "%s", $4" cores "; if (/cpu cores/) exit }' /proc/cpuinfo
uptime | awk '{ print substr($(NF-2), 1, length($(NF-2)) - 1)"% load" }'
# printf "\n";

printf "$(set_colour blue)Disk \t$(set_colour orange)-$(set_colour reset) ";
df -H / | awk '/dev/ { print $2" total, "$3" used" }'
# printf "\n";
