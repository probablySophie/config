--
-- Packages / Plugins
-- https://neovim.io/doc/user/pack.html
--

vim.pack.add({
	{ src = 'https://github.com/neovim/nvim-lspconfig' }, -- Basic LSP Configs
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter' }, -- Treesitter integration
	{ src = 'https://github.com/catppuccin/nvim' }, -- Colour Scheme,
	{ src = 'https://github.com/folke/which-key.nvim' },
	{ src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }, -- Markdown rendering
});

-- 
-- Package Config
--

-- require "plugins.lspconfig";
-- require "plugins.treesitter";
-- require "plugins.catppuccin";
require "plugins.whichkey";
require "plugins.rendermarkdown";
