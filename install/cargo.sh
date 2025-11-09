rustup update
rustup component add rust-analyzer

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

cargo install --git https://github.com/latex-lsp/texlab --locked

# Adding aliases
mkdir -p ~/.local/completions

bat --completion bash > ~/.local/completions/bat.sh
echo "source ~/.local/completions/bat.sh" >> ~/.bashrc

rg --generate complete-bash > ~/.local/completions/ripgrep.sh
echo "source ~/.local/completions/ripgrep.sh" >> ~/.bashrc

if command -v notify-send &> /dev/null ; then
	notify-send "Finished Installing!" -a "cargo.sh"
fi
