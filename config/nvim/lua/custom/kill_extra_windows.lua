
function KILL_EXTRAS()

	local kill_filetypes = { '', 'help', 'lspinfo', 'notify', 'checkhealth' };

	local windows = vim.api.nvim_list_wins();
	local tab = vim.api.nvim_get_current_tabpage();
	local tab_win = vim.api.nvim_tabpage_get_win( tab );
	local win = vim.api.nvim_tabpage_get_win( tab );

	local function should_close( win_id )
		-- -- Don't close the main tab window
		-- if win_id == tab_win then return false; end
		local conf = vim.api.nvim_win_get_config( win_id );
		-- Close relative windows
		if conf.relative == "win" and conf.win == win then return true; end
		local win_buf = vim.api.nvim_win_get_buf( win_id );
		-- Close windows with buffer filetypes in our kill list
		for _,ft in ipairs(kill_filetypes) do if ft == vim.bo[win_buf].filetype then return true; end; end
		return false;
	end

	local strs = "";
	for _,win2 in ipairs(windows) do
		if should_close( win2 ) then
			vim.api.nvim_win_close( win2, false )
		elseif win2 ~= tab_win then
			local win_buf = vim.api.nvim_win_get_buf( win2 );
			local conf = vim.api.nvim_win_get_config( win2 );
			strs = strs .. string.format(
				"win %d, buf %d, filetype %s, relative? %s, same tab? %s",
				win2,
				win_buf,
				vim.bo[win_buf].filetype,
				conf.win == win and "yes" or "no",
				vim.api.nvim_win_get_tabpage(win2) == tab and "yes" or "no"
			) .. "\n";
		end
	end
	if #strs > 0 then vim.print(strs); end
end


