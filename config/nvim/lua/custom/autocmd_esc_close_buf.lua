-- Close certain buffers on <Esc>
vim.api.nvim_create_autocmd( { 'BufEnter' }, {
	callback = function(args)
		local buf = args.buf;
		local buf_type = vim.bo[buf].filetype;
		local types = { 'help' }; -- Filetypes to close
		local found = false;
		for _,t in ipairs(types) do -- If this buffer is in our list of buffer types
			if t == buf_type then
				found = true;
				-- Create a buffer keybind <Esc> -> Close
				vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '', {
					callback = function() vim.api.nvim_command('close'); end
				});
			end
		end
		if not found then print( buf_type ); end
	end,
} );


