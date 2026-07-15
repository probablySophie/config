
local win_close_group = vim.api.nvim_create_augroup('TempWindow', {clear = true});

local buffer = vim.api.nvim_create_buf( true, false );
local enter = true;
local config = {
	relative = 'cursor',
	-- split = "right",
	-- win = 0,
	width = 30,
	height = 7,
	col = 0,
	row = 1,
	style = "minimal"
};
local window = vim.api.nvim_open_win( buffer, enter, config );

-- INFO: Opening a terminal in the window?
-- local term = vim.api.nvim_open_term(buffer, {
-- 	force_crlf = false,
-- 	-- on_input = function (_, term, bufnr, data)
-- 	--
-- 	-- end
-- });
-- vim.api.nvim_chan_send(term, "ls\n");

-- INFO: I run on window close
vim.api.nvim_create_autocmd('WinClosed', {
	pattern = tostring(window),
	group = win_close_group,
	callback = function (args)
		local window = tonumber( args.match );
		if window ~= nil then
			local buffer = vim.api.nvim_win_get_buf(window);
			vim.api.nvim_buf_delete( buffer, { force = true, unload = true } );
		end
		-- print(string.format([[Window #%d is closing]], window));
	end,
	once = true, -- delete after firing
})
