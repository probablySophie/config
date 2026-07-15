--
-- Packages / Plugins
-- https://neovim.io/doc/user/pack.html
--

-- INFO: You may also want ./lsps.lua

vim.pack.add({
	{ src = 'https://github.com/neovim/nvim-lspconfig' }, -- Basic LSP Configs
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' }, -- Treesitter integration
	{ src = 'https://github.com/catppuccin/nvim' }, -- Colour Scheme,
	{ src = 'https://github.com/folke/which-key.nvim' },
	{ src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }, -- Markdown rendering
	{ src = 'https://github.com/nvim-mini/mini.nvim' }, -- Just a million tiny guys
});

vim.cmd.colorscheme "catppuccin-mocha"; -- colour-scheme
-- 
-- Package Config
--

-- require "plugins.lspconfig";
-- require "plugins.treesitter";
-- require "plugins.catppuccin";
require "plugins.whichkey";
require "plugins.rendermarkdown";
require "plugins.mini";
