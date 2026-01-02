FILE="nvim-linux-x86_64";

NIGHTLY="https://github.com/neovim/neovim/releases/download/nightly/$FILE.tar.gz"
LATEST="https://github.com/neovim/neovim/releases/latest/download/$FILE.tar.gz"

SAVE_TO="$HOME/Downloads/nvim.tar.gz";

# TODO: Prompt the user for nightly or latest

# curl -L "$NIGHTLY" -o "$SAVE_TO";
# tar -xf "$SAVE_TO" -C "$HOME/Downloads/"

cp -r "$HOME/Downloads/$FILE"/* "$HOME/.local"
# FOLDERS=( "bin" "lib" "share" )
# for FOLDER in "${FOLDERS[@]}"; do
# 	# printf "$FOLDER\n";
# 	mkdir -p "$HOME/.local/$FOLDER"

# done 

# TODO: Ask user if they want to clean up downloads folder

