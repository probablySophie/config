yellow=$(tput setaf 11)
green=$(tput setaf 10)
red=$(tput setaf 9)
normal=$(tput sgr0)

# Files link destination

function symlink
{
	local file=$1
	local link_to=$2
	# Make sure the file we're linking from actually exists
	if [[ -f $file ]] || [[ -d $file ]]; then
		printf "\t${file##*/}\n";
		ln -sf $file $link_to;
	fi
}

function bulk_symlink
{
	printf "\nInput:  $1\n";
	printf "Output into: $2\n";
	for file in $1/*; do
		symlink $file $2
	done
	for file in $1/.*; do
		symlink $file $2
	done
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
