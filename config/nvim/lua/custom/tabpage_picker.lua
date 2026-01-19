--[[
	A picker for the current tabpages :)
]]

local function size_table_row(row, sizes)
	for key,val in pairs(row) do
		local size = string.len( tostring( val ) );
		if sizes[key] == nil then sizes[key] = size;
		else
			if sizes[key] < size then sizes[key] = size; end
		end
	end
end


function TABPAGE_PICKER()

	local tabs = vim.api.nvim_list_tabpages();

	local SIZES = {};
	local VALUES = {};

	table.insert( VALUES, {
		tab = "Tab",
		window = "Window",
		buffer = "Buffer",
		path = "Path",
	} );
	size_table_row( VALUES[1], SIZES );

	for _,tab_id in pairs(tabs) do
		local win_id = vim.api.nvim_tabpage_get_win( tab_id );

		local buf_id = vim.api.nvim_win_get_buf( win_id );
		local buf_name = vim.api.nvim_buf_get_name( buf_id );

		local pwd = vim.fn.getcwd();

		local this_tab = {
			tab = tab_id,
			window = win_id,
			buffer = buf_id,
			path = string.gsub( string.gsub(buf_name, pwd, ''), '^/', ''),
		};

		table.insert( VALUES, this_tab );
		size_table_row( this_tab, SIZES );
	end

	local print_string = "";
	for _,t in pairs(VALUES) do
		local print_str = "";
		for key,val in pairs(t) do
			local val_string = tostring(val);
			if ( string.len(val_string) < SIZES[key] ) then
				val_string = val_string .. string.rep(' ', SIZES[key] - string.len(val_string));
			end
			print_str = print_str .. "| " .. val_string .. " "
		end
		print_string = print_string .. print_str .. "\n";
	end

	require "lua.pickers";
	open_picker({
		command = "printf '" .. print_string .. "' | fzf --scheme=history --tac",
		win_width = 0,
		win_height = #VALUES + 3,
		-- win_style = ""
	}, function(_, _, selections)
			if selections[1] == nil then return; end

			local str = selections[1];
			local index = 2;
			local string_index = 0;
			for _=1,index do
				local str_start, str_end = string.find( str, "|[^%|]*", string_index );
				if str_end == nil then return; end
				string_index = str_end;
			end
			local str_start, str_end = string.find( str, "|[^%|]*", string_index );
			if str_start == nil or str_end == nil then return; end
			local value = string.gsub(string.sub( str, str_start, str_end ), "^|", "");
			value = string.gsub( value, "^%s*", "" );
			value = string.gsub( value, "%s*$", "" );

			local num = tonumber(value);
			if num == nil then return; end

			vim.api.nvim_set_current_tabpage( num );
		end)
end
