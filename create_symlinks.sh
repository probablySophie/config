yellow=$(tput setaf 11)
green=$(tput setaf 10)
red=$(tput setaf 9)
normal=$(tput sgr0)

# Files link destination

function bulk_symlink
{
	printf "\nInput:  $1\n";
	printf "Output: $2\n";
	files=($1);
	for file in "${files[@]}"; do
		file_name="${file##*/}";
		printf "\t$file_name\n";
		ln -sf $file $2$file_name;
	done
}

bulk_symlink "$PWD/config/*" "$HOME/.config/"
bulk_symlink "$PWD/local_share/*" "$HOME/.local/share/"
