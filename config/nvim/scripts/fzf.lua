
-- INFO: Vaguely following this tutorial
-- https://elanmed.dev/blog/native-fzf-in-neovim

function run_command_in_new_window( command, window_config, handle_output )
	window_config = window_config or {
		relative = 'editor', -- editor, cursor
		-- split = "right",
		-- win = 0,
		width = vim.o.columns - 4,
		height = vim.o.lines - 4,
		col = 1,
		row = 1,
		-- style = "minimal",
		border = "rounded",
	};

	local buffer = vim.api.nvim_create_buf( false, true );
	local enter = true;
	local config = {
		relative = window_config.relative or nil,
		split = window_config.split or nil,
		win = window_config.win or nil,
		width = window_config.width or 5,
		height = window_config.height or 5,
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

run_command_in_new_window(
	"fzf",
	{
		title = "Fzf",
		relative = "editor",
		width = vim.o.columns - 4,
		height = vim.o.lines - 4,
		border = "rounded",
	},
	function( output ) -- each item in output is a line in the output string
		if #output > 0 then
			vim.cmd( string.format([[edit %s]], output[1]) )
		end
	end
);
