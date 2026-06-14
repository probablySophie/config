GLOBAL_INSTALLS=(
	bun add -g
	@astrojs/language-server
	tailwindcss-language-server
	# tsserver
	typescript
	typescript-language-server
	vscode-langservers-extracted 
	# vscode-langservers-extracted/vscode-html-language-server 
	# vscode-langservers-extracted/vscode-css-language-server 
	# vscode-langservers-extracted/vscode-json-language-server 
	# vscode-langservers-extracted/vscode-eslint-language-server 
	bash-language-server 
	pyright 
);
"${GLOBAL_INSTALLS[@]}"

# SCLS Snippet language server
cargo install --locked --git https://github.com/estin/simple-completion-language-server.git
