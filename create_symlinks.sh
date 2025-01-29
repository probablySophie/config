
yellow=$(tput setaf 11)
green=$(tput setaf 10)
red=$(tput setaf 9)
normal=$(tput sgr0)

SOURCE_DIR=${PWD}
HOME_DIR=${HOME}"/"

FORCE=0
if [[ ! -z $1 ]]; then
	FORCE=1
	printf "${yellow}FORCE SET TO TRUE${normal}\n";
else
	printf "Not removing pre-existing files\n";
fi

printf "Copying from "${SOURCE_DIR}"\n"

create_link() { # takes source_dir dest_dir file_name

	printf "%-16s" ${3} # display the filename
	
	# Is the source_file valid
	if [ ! -f ${1}${3} ] && [ ! -d ${1}${3} ]; then
 		printf "${red}⨯\tSource file does not exist at ${1}${3}${normal}\n"
 		return
	fi
	# Is there already something there? (& not force)
	if [[ -L ${2}${3} ]] && [[ ! $FORCE==1 ]]; then
	 		printf "${green}✓\tDestination file is already a symlink${normal}\n"
	 		return
	else
		# Force? and existing file?
		if [[ $FORCE == 1 ]] && [ -f ${2}${3} ]; then
			rm "$2$3"
		# Force? and existing directory?
		else
		if [[ $FORCE == 1 ]] && [ -d ${2}${3} ]; then
			rm -rd "$2$3"
		else
		# Force? and existing Symlink?
		if [[ $FORCE == 1 ]] && [ -L ${2}${3} ]; then
			rm "$2$3";
		else
		if [[ -f ${2}${3} ]] || [[ -d ${2}${3} ]]; then
	 		printf "${red}⨯\tDestination file already exists!${normal}\n"
	 		return
		fi fi fi fi
	fi
	
	ln -s ${1}${3} ${2}${3} # all is good.  Make the link
	printf "${green}✓\tCreated symlink!${normal}\n"
	
}

# $1 Group source
# $2 Group destination
# $3 Who to do
batch_link() {
	items=("$@")
	source="${items[0]}"
	dest="${items[1]}"
	for ((i=2; i<${#items[@]}; i++)); do
		create_link "$source" "$dest" "${items[$i]}"
	done
}


if [[ $FORCE == 0 ]]; then

	if [[ -L ~/.bashrc ]]; then
		printf ".bashrc already linked :)${normal}\n";
	else
		if [ -f ~/.bashrc ]; then
			printf "${yellow}THERE IS ALREADY A .BASHRC FILE, PLEASE DELETE THAT MANUALLY AND RUN THIS FILE AGAIN${normal}\n"
		fi
	fi
else
	
	if [ -f ~/.bashrc ]; then
		rm ~/.bashrc
	fi
fi

# TODO: Compress these down into a nicer form

create_link ${SOURCE_DIR} ${HOME_DIR} ".bashrc"

# Make our .config/ symlinks
batch_link "${SOURCE_DIR}" "$HOME_DIR.config/" \
	"bash" "starship.toml"  \
	"tmux" "alacritty" "helix" \
	 "yazi"

# ~/.gitconfig
create_link ${SOURCE_DIR} ${HOME_DIR} ".gitconfig"

# ~/.local/share/nap
create_link ${SOURCE_DIR} ${HOME_DIR}".local/share/" "nap"

