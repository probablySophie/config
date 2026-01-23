

[Floating window example](https://www.statox.fr/posts/2021/03/breaking_habits_floating_window/) 

## Tabs

```lua
-- List windows within a given tabpage (0 for current tab)
vim.print(vim.api.nvim_tabpage_list_wins( tab_id ))
```

## Run lua file

```sh
:luafile % # To run current file
```

## Making a buffer

```lua
-- https://neovim.io/doc/user/api.html#nvim_create_buf()
local new_buffer = vim.api.nvim_create_buf(
	false, -- Show on the buffer list?
	true, -- Create a scratch buffer? https://neovim.io/doc/user/windows.html#scratch-buffer
);
```

## Buffer Info

```lua
local buf = vim.api.nvim_get_current_buf();
local buf_type = vim.bo[buf].filetype; -- The buffer's type, e.g. 'help', 'markdown', 'lua'
```

## Making a floating window
```lua
local buffer = 1;
local window_title = 'Hi there!';
-- local current_ui = nvim_list_uis()[0]; -- and can then use for width & height

-- https://neovim.io/doc/user/api.html#_win_config-functions
-- https://neovim.io/doc/user/api.html#api-floatwin
vim.api.nvim_open_win(
	buffer, -- the buffer id to show in the window
	true, -- focus on open? 
	{ -- config 
		relative='win', 
		width = 120, 
		height = 30, 
		row=20, -- left 
		col=20, -- top
		title=window_title,
		win=1001, -- Which window will be split (if splitting)
	}
);
```


