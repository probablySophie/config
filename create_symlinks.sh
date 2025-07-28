yellow=$(tput setaf 11)
green=$(tput setaf 10)
red=$(tput setaf 9)
normal=$(tput sgr0)

# Files link destination

function symlink
{
	local file=$1
	local link_to=$2

	# Does our friend already exist?
	if [[ -f $link_to ]] || [[ -d $link_to ]]; then
		file_output="$(file $link_to)";
		# Is it NOT a symlink?
		if [[ "! $file_output" =~ symbolic ]]; then
			printf "\t${orange}${file##*/} exists and is NOT a symlink${normal}\n";
			return
		fi
	fi
	
	# Make sure the file we're linking from actually exists
	# And make the symlink :)
	if [[ -f $file ]] || [[ -d $file ]]; then
		ln -sf $file $link_to;
		printf "\t${green}${file##*/}${normal}\n";
		return
	fi
	# If we've got here then the file doesn't exist :(
	printf "\t${red}Source file ${file} does not exist${normal}\n";
}

function bulk_symlink
{
	printf "Creating symlinks from ${bold}$1${normal} -> ${bold}$2${normal}\n";
	for file in $1/*; do
		symlink $file $2
	done
	# and also symlink hidden files please :)
	for file in $1/.*; do
		if [[ "${file##*/}" == ".*" ]]; then continue; fi
		symlink $file $2
	done
	printf "\n";
}

bulk_symlink "$PWD/config" "$HOME/.config/"
bulk_symlink "$PWD/local_share" "$HOME/.local/share/"

# Update ~/.bashrc to source our custom files if it doesn't already
if [[ "$(grep -c 'include custom bash setup if it exists' ~/.bashrc)" == "0" ]]; then
	printf "# include custom bash setup if it exists\n"\
"if [ -f \$HOME/.config/bash/custom.sh ]; then\n"\
"    . \$HOME/.config/bash/custom.sh\n"\
"fi\n" >> ~/.bashrc
	printf "Updated ~/.bashrc\n";
fi
