-- Mini.nvim

-- TODO: Use some of these friends?
-- https://nvim-mini.org/mini.nvim/doc/mini-trailspace.html (Showing and removing trailing whitespace)
-- https://nvim-mini.org/mini.nvim/doc/mini-bracketed.html
-- https://nvim-mini.org/mini.nvim/doc/mini-git.html (A full git client)
-- https://nvim-mini.org/mini.nvim/doc/mini-input.html (Get user input)
-- https://nvim-mini.org/mini.nvim/doc/mini-sessions.html
-- https://nvim-mini.org/mini.nvim/doc/mini-keymap.html
-- https://nvim-mini.org/mini.nvim/doc/mini-snippets.html
-- https://nvim-mini.org/mini.nvim/doc/mini-clue.html

-- https://nvim-mini.org/mini.nvim/doc/mini-comment.html#minicomment.setup
require('mini.comment').setup({
	mappings = {
		comment_line = '<leader>c',
		comment_visual = '<leader>c'
	},
});

-- Icons for the other mini packages
require('mini.icons').setup();

-- https://nvim-mini.org/mini.nvim/doc/mini-tabline.html
require('mini.tabline').setup({
	show_icons = true,
	tabpage_section='none',
	format = function(buffer_id, label)
		local suffix = vim.bo[buffer_id].modified and '[+]' or '';
		return MiniTabline.default_format(buffer_id, label) .. suffix;
	end
});

local colourscheme = require("catppuccin.palettes").get_palette "mocha";

local selected_hl = { fg = colourscheme.mauve, bg = 'bg' };
local not_selected_hl = { fg = 'fg', bg = colourscheme.mantle };

-- https://nvim-mini.org/mini.nvim/doc/mini-tabline.html#minitabline-hl-groups
vim.api.nvim_set_hl(0, 'MiniTablineCurrent', selected_hl);
-- vim.api.nvim_set_hl(0, 'MiniTablineVisible', basic_hl());
vim.api.nvim_set_hl(0, 'MiniTablineHidden', not_selected_hl);
vim.api.nvim_set_hl(0, 'MiniTablineModifiedCurrent', selected_hl);
-- vim.api.nvim_set_hl(0, 'MiniTablineModifiedVisible', basic_hl());
vim.api.nvim_set_hl(0, 'MiniTablineModifiedHidden', not_selected_hl);
vim.api.nvim_set_hl(0, 'MiniTablineFill', { fg = 'fg', bg = colourscheme.crust });
-- vim.api.nvim_set_hl(0, 'MiniTablineTagpagesection', basic_hl());
-- vim.api.nvim_set_hl(0, 'MiniTablineTrunc', basic_hl());


-- https://nvim-mini.org/mini.nvim/doc/mini-pairs.html#minipairs.setup
require('mini.pairs').setup();

local chars = { '[]', '{}', '()', '<>' };
local custom_surroundings = {};
for i=1,#chars do
	custom_surroundings[string.sub(chars[i], 1, 1)] = { output = {
		left = string.sub(chars[i], 1, 1),
		right = string.sub(chars[i], 2, 2),
	} };
end

-- https://nvim-mini.org/mini.nvim/doc/mini-surround.html
-- Using Helix keybinds
require('mini.surround').setup({
	mappings = {
		add = 'ms',
		delete = 'md',
		replace = 'mr',
	},
	custom_surroundings = custom_surroundings,
});
-- TODO: How do we get this friend to not exit visual mode on surrounding?

-- https://nvim-mini.org/mini.nvim/doc/mini-files.html
require('mini.files').setup({
	content = {
		filter = nil,
		highlight = nil,
		prefix = nil,
		sort = nil,
	},
	mappings = {
		close = '<Esc>', -- close the popup
		go_in = '<Right>',
		go_in_plus = '<CR>', -- goes in or opens & closes the popup,
		go_out_plus = '<Left>',
	},
});

-- Also see ../keymaps.lua for more selection stuff
vim.keymap.set('n', '<leader>f', ':lua MiniFiles.open(nil, false)<CR>', { desc = 'Open file picker in current root directory' });
vim.keymap.set('n', '<leader>F', ':lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<CR>', { desc = 'Open file picker in working directory' });


-- https://nvim-mini.org/mini.nvim/doc/mini-notify.html
require('mini.notify').setup({
	content = {
		-- format = nil,
		-- sort = nil,
	},
	-- Specifically LSP progress notifications
	lsp_progress = {
		enable = true,
		level = 'INFO',
		duration_last = 1000
	},
	window = {
		config = {},
		max_width_share = 0.5,
		-- winblend = 25,
	},
});

-- https://nvim-mini.org/mini.nvim/doc/mini-cmdline.html
require('mini.cmdline').setup();

-- https://nvim-mini.org/mini.nvim/doc/mini-starter.html
require('mini.starter').setup({
	autoopen = true,
	items = nil,
	header = 'You\'re using NeoVim :)',
	footer = nil,
	content_hooks = nil,
	query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789_-.',
	silent = false
});

-- https://nvim-mini.org/mini.nvim/doc/mini-completion.html
require('mini.completion').setup();

-- MiniStatuslineModeNormal - Normal mode.
-- MiniStatuslineModeInsert - Insert mode.
-- MiniStatuslineModeVisual - Visual mode.
-- MiniStatuslineModeReplace - Replace mode.
-- MiniStatuslineModeCommand - Command mode.
-- MiniStatuslineModeOther
-- require('mini.statusline').setup({
-- 	content = {
-- 		active = nil,
-- 		inactive = nil,
-- 	},
-- 	use_icons = true
-- });

-- INFO: https://nvim-mini.org/mini.nvim/doc/mini-hipatterns.html#minihipatterns-examples
require('mini.hipatterns').setup({
	highlighters = {
		fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
		hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
		todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
		note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
		info = { pattern = 'INFO', group = 'MiniHipatternsTodo' },
	},
});
