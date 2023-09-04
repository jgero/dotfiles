vim.o.spelllang = "en_us,de_de"
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	callback = function()
		if vim.bo.filetype == "markdown" or vim.bo.filetype == "gitcommit" or vim.bo.filetype == "tex" then
			vim.opt_local.spell = true
		end
	end,
})
