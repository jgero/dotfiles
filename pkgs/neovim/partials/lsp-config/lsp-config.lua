local function use_exec_or_fallback(exec, fallback, ...)
	local cmd = {}
	if vim.fn.executable(exec) == 1 then
		table.insert(cmd, exec)
	else
		table.insert(cmd, fallback)
	end
	for _, arg in ipairs({ ... }) do
		table.insert(cmd, arg)
	end
	return cmd
end

vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		local function nmap_for_method(method, keys, func, desc)
			if not client:supports_method(method) then
				return
			end
			if desc then
				desc = "LSP: " .. desc
			end
			vim.keymap.set("n", keys, func, { buffer = args.buf, desc = desc })
		end
		nmap_for_method("textDocument/definition", "gd", vim.lsp.buf.definition, "[g]o to [d]efinition")
		nmap_for_method("textDocument/rename", "<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
		nmap_for_method(
			"signature_help",
			"<leader>d",
			vim.lsp.buf.signature_help,
			"show signature help [d]ocumentation"
		)
		nmap_for_method(
			"textDocument/diagnostic",
			"<leader>df",
			vim.diagnostic.open_float,
			"show [d]iagnostics [f]loat"
		)
		nmap_for_method("textDocument/codeAction", "<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ctions")
		nmap_for_method("textDocument/hover", "H", vim.lsp.buf.hover, "[H]over")
		nmap_for_method("textDocument/formatting", "<leader>lf", vim.lsp.buf.format, "[l]sp do [f]ormatting")
	end,
})
vim.lsp.config("*", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	root_markers = { ".git" },
})
