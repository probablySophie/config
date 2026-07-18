-- Keymaps!

--- Takes a vim action, calls it and then redraws
--- This is so that we can have keybinds do things without them showing in the command line
local function action_and_redraw( action )
	return function()
		action();
		vim.cmd.redraw();
	end
end
--- Perform an action without redrawing
local function action( action_cmd )
	return function() action_cmd(); end
end


vim.keymap.set({ 'v', 'i', 'n' }, '<C-s>', action( vim.cmd.write ), { desc = 'Save' }); -- insert & visual mode save
-- vim.keymap.set('n', '<leader>r', ':update<CR> :source<CR>') -- reload config

vim.keymap.set('n', '<leader>wq', action( vim.cmd.quitall ), { desc = 'Quit All' }); -- Quit all
vim.keymap.set('n', '<leader>q', action( vim.cmd.quit ), { desc = 'Quit Current' });

vim.keymap.set({ 'n' }, 'r', action( vim.cmd.redo ), { desc = 'Redo' });
vim.keymap.set({ 'n' }, 'u', action( vim.cmd.undo ), { desc = 'Undo' });


--
-- Document Navigation
--

vim.keymap.set({'v', 'n'}, 'ge', '::$<CR>', { desc = 'Goto end of document' });
vim.keymap.set({'v', 'n'}, 'gh', '0', { desc = 'Goto start of line' });
vim.keymap.set({'v', 'n'}, 'gl', '$', { desc = 'Goto end of line' });

vim.keymap.set('n', '<down>', 'gj', { desc = 'Goto the next line (respecting virtual lines)' });
vim.keymap.set('n', '<up>', 'gk', { desc = 'Goto the previous line (respecting virtual lines)' });

--
-- Buffer Navigation
--
vim.keymap.set({ 'n' }, '<C-left>', action_and_redraw( vim.cmd.bp ), { desc = 'Previous Buffer' });
vim.keymap.set({ 'n' }, '<C-right>', action_and_redraw( vim.cmd.bn ), { desc = 'Previous Buffer' });
-- TODO: How do we bind Shift-left and Shift-right?

vim.keymap.set({ 'n' }, 'W', ':bd<CR>', { desc = 'Close Buffer' });

--
-- Tab Navigation
-- https://neovim.io/doc/user/tabpage.html
--
-- vim.keymap.set({ 'n' }, '<C-left>', action_and_redraw( vim.cmd.tabprev ), { desc = 'Previous Tab' });
-- vim.keymap.set({ 'n' }, '<C-right>', action_and_redraw( vim.cmd.tabnext ), { desc = 'Next Tab' });
-- vim.keymap.set({ 'n' }, 'W', ':q<CR>', { desc = 'Close Tab' });
-- TODO: Only tab close if saved
for i = 1,9 do vim.keymap.set({ 'n', 't' }, '<leader>w' .. i, '<Cmd>tabnext ' .. i .. '<CR>', { desc = 'Open Tab #' .. i } ); end

-- TODO: Also see https://neovim.io/doc/user/windows.html

-- 
-- Buffers
-- 
-- vim.keymap.set('n', '<A-left>', ':bprev<CR>:redraw<CR>', { desc = 'Previous Buffer' });
-- vim.keymap.set('n', '<A-right>', ':bnext<CR>:redraw<CR>', { desc = 'Next Buffer' });


--
-- Helix style selection stuff
--

-- Also see ./plugins/mini.lua for more 

vim.keymap.set('v', 'x', 'V', { desc = 'Expand selection' });
vim.keymap.set('n', 'mi', 'vi', { desc = 'Select within' });
vim.keymap.set('n', 'ma', 'va', { desc = 'Select around' });

-- TODO: Map Visual mode 's' to select within selection 

--
-- Folding
--
vim.keymap.set('n', 'ff', 'za', { desc = 'Toggle Fold' });

--
-- Misc
--

-- General escape command
require "custom.kill_extra_windows";
vim.keymap.set( 'n', '<Esc>', function()
	vim.cmd('nohlsearch'); -- Clear highlights
	KILL_EXTRAS();
end )

vim.keymap.set('n', '>', 'v>', { desc = 'Indent line' });
vim.keymap.set('n', '<', 'v<', { desc = 'Unindent line' });

--
-- LSP Commands
-- https://neovim.io/doc/user/lsp.html#lsp-defaults
--
vim.keymap.set( 'n', '<leader>r', ':lua vim.lsp.buf.rename()<CR>', { desc = 'Rename Symbol' } ); -- Rename
-- vim.keymap.set( 'n', '<leader>r', ':lua vim.lsp.buf.rename()<CR>' ); -- Rename
vim.keymap.set( 'n', '<leader>a', ':lua vim.lsp.buf.code_action()<CR>', { desc = 'Show Code Actions' }  ); -- Code Actions
-- Shift-K hover (default)
vim.keymap.set( 'n', '<leader>h', ':lua vim.lsp.buf.signature_help()<CR>', { desc = 'Signature Help' }  ); -- Help

-- vim.keymap.set('i', '<C-space>', vim.lsp.buf.completion); -- Show completion options

-- TODO: Open wikipedia
vim.keymap.set('v', '<leader>xw',
	function()
		local region = vim.fn.getregion( vim.fn.getpos("v"), vim.fn.getpos(".") );
		vim.print(region);
	end,
	{ desc = '?' } );

-- TODO: gf (goto file) should browser open URLs


--
-- Pickers
--

-- Fancy previewing with fzf :)
-- local fzf_preview_cmd = 'if command -v bat &> /dev/null; then bat --color=always {}; else cat {}; fi';

local function edit_all( lines )
	if lines == nil or #lines == 0 then return; end
	for _,line in ipairs(lines) do
		vim.cmd( string.format( [[edit %s]], line ) );
	end
end

require "custom.windows";
vim.keymap.set( 'n', '<C-o>',
	function()
		run_command_in_new_window(
			"fzf -m",
			{
				title = "Open file(s)",
				relative = "editor",
				border = "rounded",
			},
			function(l) edit_all(l); end
		)
	end,
	{ desc = 'Open fzf file picker' }
);

