
COMPLETIONS_DIR="$HOME/.local/completions";
mkdir -p "$COMPLETIONS_DIR"

if command -v rg &> /dev/null; then
	rg --generate complete-bash >> "$COMPLETIONS_DIR/rg.sh"
fi

if command -v rustup &> /dev/null; then
	# Do the thing
	rustup completions bash >> "$COMPLETIONS_DIR/rustup.sh"
	rustup completions bash cargo >> "$COMPLETIONS_DIR/cargo.sh"
fi
