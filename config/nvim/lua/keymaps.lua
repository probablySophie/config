-- Keymaps!
vim.keymap.set({ 'v', 'i' }, '<C-s>', '<C-O>:write<CR>', { desc = 'Save' }); -- insert & visual mode save
vim.keymap.set('n', '<C-s>', ':write<CR>'); -- normal mode save
-- vim.keymap.set('n', '<leader>r', ':update<CR> :source<CR>') -- reload config

vim.keymap.set('n', '<leader>wq', ':quitall<CR>', { desc = 'Quit All' }); -- Quit all 

vim.keymap.set({ 'n' }, 'r', ':redo<CR>', { desc = 'Redo' });
vim.keymap.set({ 'n' }, 'u', ':undo<CR>', { desc = 'Undo' });

-- vim.keymap.set('n', '<leader>wq', ':quit<CR>', { desc = 'Close Tab/Buffer' } ) -- Quit singular

--
-- Navigation
--

vim.keymap.set({'v', 'n'}, 'ge', '::$<CR>', { desc = 'Goto end of document' });
vim.keymap.set({'v', 'n'}, 'gh', '0', { desc = 'Goto start of line' });
vim.keymap.set({'v', 'n'}, 'gl', '$', { desc = 'Goto end of line' });

--
-- Tabs
-- https://neovim.io/doc/user/tabpage.html
--
vim.keymap.set({ 'n' }, '<C-left>', ':tabprev<CR>:redraw<CR>', { desc = 'Previous Tab' });
vim.keymap.set({ 'n' }, '<C-right>', ':tabnext<CR>:redraw<CR>', { desc = 'Next Tab' });
vim.keymap.set({ 'n' }, 'W', ':q<CR>', { desc = 'Close Tab' });
-- TODO: Only tab close if saved
for i = 1,9 do vim.keymap.set({ 'n', 't' }, '<leader>w' .. i, '<Cmd>tabnext ' .. i .. '<CR>', { desc = 'Open Tab #' .. i } ); end

-- TODO: Also see https://neovim.io/doc/user/windows.html

-- 
-- Buffers
-- 
vim.keymap.set('n', '<A-left>', ':bprev<CR>:redraw<CR>', { desc = 'Previous Buffer' });
vim.keymap.set('n', '<A-right>', ':bnext<CR>:redraw<CR>', { desc = 'Next Buffer' });

--
-- Folding
--
vim.keymap.set('n', 'ff', 'za', { desc = 'Toggle Fold' });


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

-- TODO: <C-o> should open a yazi or fzf window & allow us to pick a file 
-- TODO: gf (goto file) should browser open URLs

--
-- Pickers
--
require "pickers";
vim.keymap.set( 'n', '<C-o>', function() open_picker({
	command = "fzf -m",
	-- win_width = 0,
	-- win_height = 0,
	-- x = 0,
	-- y = 0,
	-- win_style = ""
}) end, { desc = 'Open file picker' } )
-- TODO: Have a little preview of the files
