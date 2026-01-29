# rustup update
# rustup component add rust-analyzer

INSTALL_LOCKED=(
	"starship" # Pretty bash prompts	https://starship.rs/
	"bottom" # A better top/system-monitor
	"tuifeed"
	"cargo-expand"
	"bat"
	# "yazi-fm\ yazi-cli"
);
INSTALL_LOCKED_FORCE=( "yazi-build" );
INSTALL=(
	"eza"
	"fd-find"
	"ripgrep"
);
INSTALL_GIT=();
INSTALL_GIT_LOCKED=(
	"https://github.com/latex-lsp/texlab"
);

# Cargo install --list
# cargo install --list | grep ^starship

function get_installed_version
{
	BIN="$1";
	INSTALLED_VERSION="$(cargo install --list | grep "^$BIN" | cut -d " " -f 2 | sed -e s/://g)";
	printf "$INSTALLED_VERSION";
}
function get_latest_version
{
	BIN="$1";
	LATEST_VERSION="v$(cargo info "$BIN" -q | grep ^version | cut -d " " -f 2)";
	printf "$LATEST_VERSION";
}

function install_bin
{
	printf "\t$(tput setaf 7)$2 $1..."; # ${Verb} ${binary name}...
	CMD=(
		cargo install -j 1
	);

	if [[ "$3" == "" ]]; then printf "$(tput sgr0)\n"; else printf " ($3) $(tput sgr0)\n"; fi
	# Install using one thread (so we don't freeze up our awful laptop) and quietly
	if [[ "$3" == *"locked"* ]]; then
		CMD+=( --locked );
		# cargo install -j 1 --locked "$1";# 2>&1 | grep -v "^\s*Compiling ";
	fi
	if [[ "$3" == *"force"* ]]; then CMD+=( --force ); fi
	if [[ "$3" == *"git"* ]]; then
		CMD+=( --git );
		# cargo install -j 1 --git "$1";# 2>&1 | grep -v "^\s*Compiling ";
	fi
	# if [[ "$3" == "git locked" ]]; then
	# 	cargo install -j 1 --locked --git "$1";# 2>&1 | grep -v "^\s*Compiling ";
	# # else
	# 	cargo install -j 1 "$1";# 2>&1 | grep -v "^\s*Compiling ";
	# fi

	CMD+=( "$1" );

	for item in "${CMD[@]}"; do printf "%s" "$item "; done; printf "\n";

	"${CMD[@]}"

	printf "\t$(tput setaf 7)Done$(tput sgr0)\n";
	if command -v notify-send &> /dev/null ; then
		notify-send "Finished $2 $1!" -a "cargo.sh";
	fi
}

function install_or_update
{
	BIN="$1";
	INSTALLED_VERSION="$(get_installed_version "$BIN")";
	printf "$BIN\n";

	if [[ "$INSTALLED_VERSION" == "" ]]; then
		install_bin "$BIN" "Installing" "$2"
		return
	fi

	LATEST_VERSION="$(get_latest_version "$BIN")";
	if [[ "$INSTALLED_VERSION" != "$LATEST_VERSION" ]]; then
		install_bin "$BIN" "Updating" "$2"
		return
	fi
	printf "\t$(tput setaf 7)Up to date$(tput sgr0)\n";
}

printf "$(tput bold)Installs and updates will take a WHILE to complete, so don't worry too much about it appearing to sit and do nothing$(tput sgr0)\n";

COUNT=$(( 0
	+ ${#INSTALL[@]}
	+ ${#INSTALL_LOCKED[@]}
	+ ${#INSTALL_LOCKED_FORCE[@]}
	+ ${#INSTALL_GIT[@]}
	+ ${#INSTALL_GIT_LOCKED[@]}
));
INDEX=0;

for item in "${INSTALL[@]}"; do
	printf "($INDEX/$COUNT) "; INDEX=$(( INDEX + 1 ));
	install_or_update "$item" "";
done
for item in "${INSTALL_LOCKED[@]}"; do
	printf "($INDEX/$COUNT) "; INDEX=$(( INDEX + 1 ));
	install_or_update "$item" "locked";
done
for item in "${INSTALL_LOCKED_FORCE[@]}"; do
	printf "($INDEX/$COUNT) "; INDEX=$(( INDEX + 1 ));
	install_or_update "$item" "locked force";
done
for item in "${INSTALL_GIT[@]}"; do
	printf "($INDEX/$COUNT) "; INDEX=$(( INDEX + 1 ));
	install_or_update "$item" "git";
done
for item in "${INSTALL_GIT_LOCKED[@]}"; do
	printf "($INDEX/$COUNT) "; INDEX=$(( INDEX + 1 ));
	install_or_update "$item" "git locked";
done


# cargo install starship --locked # starship makes our bash prompt prettier

# cargo install bottom --locked # Top replacement

# cargo install tuifeed --locked # TUI Rss feeds (probs going to replace)
# cargo install cargo-expand --locked # More cargo bits
# cargo install eza # An ls replacer (that also replaces exa)
# cargo install bat --locked # A cat replacer

# # The Yazi TUI file manager & fd/ripgrep for file searching
# cargo install --locked yazi-fm yazi-cli
# cargo install fd-find
# cargo install ripgrep

# cargo install --git https://github.com/latex-lsp/texlab --locked

# # Adding aliases
# mkdir -p ~/.local/completions

# bat --completion bash > ~/.local/completions/bat.sh
# echo "source ~/.local/completions/bat.sh" >> ~/.bashrc

# rg --generate complete-bash > ~/.local/completions/ripgrep.sh
# echo "source ~/.local/completions/ripgrep.sh" >> ~/.bashrc

if command -v notify-send &> /dev/null ; then
	notify-send --wait "Finished Installing!" --app-name="cargo.sh"
fi
