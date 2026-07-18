FILE="nvim-linux-x86_64";

if command -v uname &> /dev/null; then
	if [[ "$(uname -m)" == "aarch64" ]]; then FILE="nvim-linux-arm64"; fi
fi

NIGHTLY="https://github.com/neovim/neovim/releases/download/nightly/$FILE.tar.gz"
LATEST="https://github.com/neovim/neovim/releases/latest/download/$FILE.tar.gz"

SAVE_TO="$HOME/Downloads/nvim.tar.gz";

# INFO: Prompt the user for nightly or latest

printf "Would you like nightly or latest? (n/L)\n";
CHOICE="";
read -p "> " CHOICE;
CHOICE="$( printf "%s" "$CHOICE" | tr '[:upper:]' '[:lower:]' )";

VER=$LATEST;
if [[ "$(printf "%.1s" "$CHOICE")" == 'n' ]]; then
	printf "Downloading nightly\n";
	VER=$NIGHTLY;
else
	printf "Downloading latest\n";
fi

# INFO: The actual download

curl -L "$VER" -o "$SAVE_TO";
tar -xf "$SAVE_TO" -C "$HOME/Downloads/"

for filepath in "$HOME/Downloads/$FILE"/*; do
	filename="$( printf "%s" "${filepath##*/}" )";
	# Is that a directory?
	if [[ -d "$filepath" ]]; then
		# Is there a ~/.local version?
		if [[ -d "$HOME/.local/$filename" ]]; then
			printf "Copying $filename into ~/.local\n";
			cp -rf "$filepath"/* "$HOME/.local/$filename";
		else
			printf "ignoring $filename as there isn't a ~/.local version\n";
		fi
	else
		printf "ignoring $filename as it isn't a directory\n";
	fi
done


# TODO: Ask user if they want to clean up downloads folder

