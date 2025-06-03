
red=$(tput setaf 9)
dark_red=$(tput setaf 1)

green=$(tput setaf 10)
dark_green=$(tput setaf 2)

yellow=$(tput setaf 11)
dark_yellow=$(tput setaf 3)

orange=$(tput setaf 208)
dark_orange=$(tput setaf 166)

blue=$(tput setaf 12)
dark_blue=$(tput setaf 4)

purple=$(tput setaf 13)
dark_purple=$(tput setaf 5)

aqua=$(tput setaf 14)
dark_aqua=$(tput setaf 6)


black=$(tput setaf 0)
white=$(tput setaf 15)
grey=$(tput setaf 7)

bold=$(tput bold)
dim=$(tput dim)
italic="\033[3m"
underline="\033[4m"
reverse="\033[7m" # Reversing the foreground & background colours

normal=$(tput sgr0)


rainbow() {
	printf " ${red}${1}"
	printf "${orange}${1}"
	printf "${yellow}${1}"
	printf "${green}${1}"
	printf "${blue}${1}"
	printf "${purple}${1}${normal}\n"
}

print_colour()
{
	printf "$1$2${normal}"
}
