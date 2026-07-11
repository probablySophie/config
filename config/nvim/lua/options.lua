-- Super Basic Options Config

vim.g.mapleader = " "; -- Leader Key <3

vim.o.signcolumn = "yes"; -- Always show sign column
vim.o.termguicolors = true; -- Fancy colours
vim.o.wildignorecase = true; -- Ignore case when completing file names

vim.o.whichwrap = 'b,s,<,>,[,]'; -- Allow left/right arrows to wrap lines

-- How regularly should we update/tick
vim.o.updatetime = 1000; -- (in ms)

-- How code completions should behave
vim.o.completeopt = "menu,menuone,popup,noselect,fuzzy,preview";

--
-- Indents
--
vim.o.tabstop = 4; -- Tab size
vim.o.shiftwidth = 4; -- Tab size?
vim.o.smartindent = true;
vim.o.expandtab = false;


--
-- Visuals
--
-- vim.o.winborder = "rounded";
-- vim.o.showtabline = 2;
vim.o.number = true; -- Line Numbers
vim.o.cursorline = true; -- Highlight cursor line

vim.o.list = true;
vim.o.listchars = 'tab:│ ';

local function statusline()
	return (
		' %{mode()}' -- Current mode
		.. ' %f' -- File path
		.. ' %r' -- ?
		.. ' %m' -- ?
		.. ' %=' -- Align right
		.. ' %3l:%c ' -- Line num, char num
		.. '%2p%% ' -- Percentage way through file
		.. '%{&filetype} '
	)
end

-- I think colour schemes can be set with %#ColourName#
-- vim.o.statusline = ' %f %r %m %= %3l:%c %2p%% %{&filetype} ';
vim.opt.statusline = statusline()

--
-- Searching
--
vim.o.incsearch = true; -- Highlight matches
vim.o.ignorecase = true; -- Smart case insensitive search

