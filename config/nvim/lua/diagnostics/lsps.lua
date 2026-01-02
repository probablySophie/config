function print_lsps()
	vim.print( vim.inspect(vim.lsp.status() ) );
	local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() });
	vim.print( #clients .. " LSP clients active for buffer " .. vim.api.nvim_get_current_buf() );
	--vim.print( vim.inspect( clients ) )
	for i,v in pairs(clients) do
		if i > 1 then vim.print(" "); end
		if type(v.name) == "string" then
			vim.print("Client: " .. v.name);
		end
		if type(v.server_info) == "table" and type(v.server_info.name) == "string" then
			vim.print("Server: " .. v.server_info.name);
		end
	end
end

print_lsps();

vim.api.nvim_clear_autocmds({ event = "LspNotify" });
vim.api.nvim_create_autocmd('LspNotify', {
  callback = function(args)
    local bufnr = args.buf;
    local client_id = args.data.client_id;
    local method = args.data.method;
    local params = args.data.params;

	-- the document changed
	if method == 'textDocument/didChange' then return; end

	-- Saved the current document
	if method == 'textDocument/didSave' then return; end

	-- Opened a document!
	if method == 'textDocument/didOpen' then return; end
	
	vim.print( vim.inspect( args.data ) );
  end,
})
--[[
{
  client_id = 2,
  params = {
    token = 2,
    value = {
      cancellable = false,
      kind = "begin",
      message = "0/228",
      percentage = 0,
      title = "Loading workspace"
    }
  }
}
]]

