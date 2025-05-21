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
vim.keymap.set("n", "<Leader>ai", function ()
	vim.cmd([[packadd jgero-pack-ai]])
	vim.cmd([[packadd minuet-ai.nvim]])
	require("jgero-pack-ai")
end, { desc = "start [a][i] (AI/LLM) completion" })
