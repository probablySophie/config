require ("options"); -- General vim/nvim options
require ("keymaps"); -- Keymaps & Keybinds
require ("packs"); -- Packs/Plugins
require ("lsps"); -- LSP config stuff & diagnostic stuff
--[[
	People's Configs
	https://github.com/radleylewis/nvim-lite/blob/master/init.lua
	https://github.com/SylvanFranklin/.config/blob/main/nvim/init.lua
]]

--
-- Folds
--

vim.opt.foldmethod = "expr";
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()";
vim.opt.foldlevel = 99; -- How much to fold on document load
-- vim.opt.foldcolumn = "0"
-- vim.opt.foldtext = ""
-- vim.opt.foldnestmax = 0;

-- TODO: Custom syntax highlighting? e.g. for TODOs?
-- 	https://neovim.io/doc/user/syntax.html


-- https://neovim.io/doc/user/sign.html
local symbols = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
for name, icon in pairs(symbols) do
	local hl = "DiagnosticSign" .. name
	vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

vim.cmd.colorscheme "catppuccin-mocha"; -- colour-scheme
-- TODO: Darken the background colour

