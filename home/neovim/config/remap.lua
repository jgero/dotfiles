vim.keymap.set("n", "<leader>+", ":resize +1<cr>", { desc = "grow current split" })
vim.keymap.set("n", "<leader>-", ":resize -1<cr>", { desc = "shrink current split" })
vim.keymap.set("", "<leader>y", '"+y', { desc = "copy to clipboard" })
vim.keymap.set("", "<leader>p", '"+p', { desc = "paste from clipboard" })
vim.keymap.set("", "<leader>P", '"+P', { desc = "paste from clipboard" })
vim.keymap.set(
	"n",
	"<CR>",
	'{ -> v:hlsearch ? ":nohl\\<CR>" : "\\<CR>" }()',
	{ expr = true, desc = "reset search highlight" }
)
