
-- INFO: Vaguely following this tutorial
-- https://elanmed.dev/blog/native-fzf-in-neovim

function run_command_in_new_window( command, window_config, handle_output )
	window_config = window_config or {
		relative = 'editor', -- editor, cursor
		-- split = "right",
		-- win = 0,
		-- style = "minimal",
		border = "rounded",
	};
	-- TODO: A bunch of these config friends are required but can be one or the other (e.g. relative &... something else?) so we need to check if *any* of them are set and then set one if none

	local buffer = vim.api.nvim_create_buf( false, true );
	local enter = true;
	local config = {
		relative = window_config.relative or nil,
		split = window_config.split or nil,
		win = window_config.win or nil,
		width = window_config.width or vim.o.columns - 4,
		height = window_config.height or vim.o.lines - 4,
		col = window_config.col or 1,
		row = window_config.row or 1,
		style = window_config.style or nil,
		border = window_config.border or nil,
		title = window_config.title or nil,
		-- relative = window_config.relative or nil,
	};

	local window = vim.api.nvim_open_win( buffer, enter, config );

	-- vim.api.nvim_set_current_buf(term);

	local temp_file = vim.fn.tempname();
	local window_cmd = string.format([[%s > %s]], command, temp_file);

	vim.fn.jobstart( window_cmd,
		{ term = true,
			on_exit = function()
				vim.api.nvim_win_close( window, true );
				vim.api.nvim_buf_delete( buffer, { force = true; unload = true } );
				local cmd_output = vim.fn.readfile( temp_file );
				if type(handle_output) == "function" then
					handle_output( cmd_output );
				end
				vim.fn.delete( temp_file );
			end
		} );
	vim.cmd "startinsert"
end
