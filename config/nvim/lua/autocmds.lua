--- Create a new tab-page with the given buffer id
--- Returns tab_id, tab_win_id, buffer_id
function NEW_TAB_WITH_BUFFER( buffer_id )
	vim.cmd( 'tabnew' );
	local new_tab = vim.api.nvim_list_tabpages()[ #vim.api.nvim_list_tabpages()];
	local tab_win = vim.api.nvim_tabpage_get_win(new_tab);
	local tab_win_buf = vim.api.nvim_win_get_buf( tab_win );
	vim.api.nvim_win_set_buf( tab_win, buffer_id );
	-- Delete the auto-created buf
	vim.api.nvim_buf_delete( tab_win_buf, {} );
	return new_tab, tab_win, buffer_id
end

-- If we open nvim with multiple buffers and don't use the -p flag, automatically open them in new tab-pages
vim.api.nvim_create_autocmd( 'VimEnter', { callback = function()
	local bufs = vim.api.nvim_list_bufs();
	local tabs = vim.api.nvim_list_tabpages();

	local function has_tab( buf_id )
		for _,tab in  ipairs(tabs) do
			local tab_win = vim.api.nvim_tabpage_get_win( tab );
			local tab_buf = vim.api.nvim_win_get_buf( tab_win );
			if tab_buf == buf_id then return true; end
		end
		return false
	end

	for _,buf in ipairs(bufs) do
		if not has_tab(buf) then
			local _, tab_win = NEW_TAB_WITH_BUFFER( buf );
			-- Detect the window's buffer's filetype so we can have LSPs and colouration
			vim.api.nvim_win_call( tab_win, function() vim.cmd('filetype detect') end );
		end
	end
end } )

