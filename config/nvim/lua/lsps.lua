-- 
-- Configuring LSPs
--

-- Auto complete :)
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(env)
		local client = vim.lsp.get_client_by_id(env.data.client_id);
		if client == nil then return; end
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, env.buf, {autotrigger = true});
		end
	end
});
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'rust', 'markdown', 'typescript', 'javascript', 'c', 'python' },
  callback = function() vim.treesitter.start() end,
});

-- Show diagnostics on cursor wait BUT only if there's not currently a relative floating window open
vim.api.nvim_create_autocmd({"CursorHoldI", "CursorHold"}, {
	callback = function()
		local win = vim.api.nvim_get_current_win();
		-- Is there an existing window that's already relative to our current window?
		for _,child_win in ipairs( vim.api.nvim_list_wins() ) do
			local conf = vim.api.nvim_win_get_config(child_win);
			if conf.relative == "win" and conf.win == win then return; end
		end
		-- Open a diagnostic float :)
		vim.diagnostic.open_float();
	end
});
-- Loading/workspace notification
vim.api.nvim_create_autocmd('LspProgress', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id( ev.data.client_id ) or {};
		local value = ev.data.params.value or {};
		local name = client.name or "error_name";
		local event = value.title or "";
		local message = value.message or "";

		if value.kind == 'report' then
			vim.print( name .. ': ' .. event .. " " .. message );
		end
	end
})


-- https://neovim.io/doc/user/diagnostic.html#diagnostic-highlights
-- TODO: Something with lua vim.diagnostic.open_float()
--		https://oneofone.dev/post/neovim-diagnostics-float/

vim.diagnostic.config({ -- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.Opts
	virtual_lines = true, -- Underline virtual line diagnostics 
	underline = true,
	virtual_text = false, -- End of line diagnostics
	severity_sort = true,
	float = { -- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.Opts.Float
		border = "rounded",
		scope = "cursor",
		source = true,
		header = "Diagnostics:",
	},
	signs = { -- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.Opts.Signs
		text = {
			[vim.diagnostic.severity.ERROR] = '󰅙',
			[vim.diagnostic.severity.WARN] = '',
			[vim.diagnostic.severity.INFO] = '󰋼',
			[vim.diagnostic.severity.HINT] = '󰌵',
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = 'ErrorMsg',
		},
		numhl = {
			[vim.diagnostic.severity.WARN] = 'WarningMsg',
		},
	},
})



-- Config for all LSPs
-- https://neovim.io/doc/user/lsp.html#vim.lsp.config()
vim.lsp.config( '*', {
	-- Project roots
	root_markers = { '.git', '.helix' };
} );

-- https://neovim.io/doc/user/lsp.html#vim.lsp.enable()
vim.lsp.enable({
	"lua_ls",
	"codebook",
	"marksman"
});
