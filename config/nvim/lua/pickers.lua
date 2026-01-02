function create_window(opts)
	-- Create Buffer
	local buf = vim.fn.bufnr( opts.buf_name or opts.name or "temp", true );

	-- Create Window
	local window_id = vim.api.nvim_open_win(
		buf, -- the buffer id to show in the window
		type(opts.win_focus) == "boolean" and opts.win_focus or true, -- focus on open? 
		{ -- config 
			relative='win',
			-- vim.api.nvim_win_get_width(0)
			width = opts.win_width or 120,
			-- vim.api.nvim_win_get_height(0)
			height = opts.win_height or 30,
			row = opts.x or 20, -- left 
			col = opts.y or 20, -- top
			title = opts.win_name or "",
			-- win=1001 -- Which window will be split (if splitting)
			style = opts.win_style or "minimal",
		}
	);
	return buf, window_id
end

function open_selection_as_tabs(opts, current, selections)
	selections = edit_each_line(selections, function(s) return string.gsub( s, " ", "\\ " ); end)

	-- Refocus our original window
	vim.api.nvim_set_current_win(current.win);
	-- Open our new selections
	for i,selection in ipairs(selections) do
		vim.cmd.tabedit( selection );
	end
end

function open_picker(opts, after)
	opts = opts or {};
	after = type(after) == "function" and after or open_selection_as_tabs;
	local current = {
		win = vim.api.nvim_get_current_win(),
		buf = vim.api.nvim_get_current_buf(),
		tabs = vim.api.nvim_list_tabpages(),
	}
	local buf,win = create_window(opts);

	-- TODO: Optional pre-command to get what's being fed into fzf, e.g. nvim tabs/buffers

	-- Run command in buffer
	vim.fn.jobstart(opts.command or 'fzf', {
		term = true,
		on_exit = function(job_id, _data, event)
			local selections = read_printed_lines(buf);
		
			after( opts, current, selections );

			-- Close our picker buffer
			vim.api.nvim_buf_delete( buf, { force = true } );
			-- vim.api.nvim_win_close( win, false );
		end,
		cwd = opts.dir or nil,
	});
	-- Go into insert/terminal mode in the new window
	vim.cmd.startinsert();
end

function read_printed_lines( buf )
	local lines = {}

	local i = 0;
	local win_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false);

	while i < #win_lines and win_lines[i] ~= "" do
		table.insert(lines, win_lines[i]);
		i = i + 1;
	end

	return lines
end

-- edit_each_line(selections, function(s) return string.gsub( s, " ", "\\ " ); end)

function edit_each_line( selections, func )
	if type(func) ~= "function" or type(selections) ~= "table" then return selections; end
	for i = 1,#selections do
		selections[i] = func(selections[i]);
	end
	return selections
end
