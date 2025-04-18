vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = { "*.templ" },
	callback = function()
		vim.bo.filetype = "templ"
	end,
})
