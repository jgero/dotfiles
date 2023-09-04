require("lsp_lines").setup()
vim.diagnostic.config({ virtual_text = false })
-- toggle diagnostics to avoid clashes
local diagnostics_active = true
vim.keymap.set("n", "<leader>td", function()
	diagnostics_active = not diagnostics_active
	if diagnostics_active then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end, { desc = "[t]oggle [d]iagnostics" })
