rustup update

cargo install starship --locked # starship makes our bash prompt prettier

cargo install bottom --locked # Top replacement

cargo install tuifeed --locked # TUI Rss feeds (probs going to replace)
cargo install cargo-expand --locked # More cargo bits
cargo install eza # An ls replacer (that also replaces exa)
cargo install bat --locked # A cat replacer

# The Yazi TUI file manager & fd/ripgrep for file searching
cargo install --locked yazi-fm yazi-cli
cargo install fd-find
cargo install ripgrep

if command -v notify-send &> /dev/null ; then
	notify-send "Finished Installing!" -a "cargo.sh"
fi
