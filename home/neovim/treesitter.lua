require('nvim-treesitter.configs').setup({
	auto_install = true,
	highlight = {
		enable = true
	},
	incremental_selection = {
		enable = true
	},
	indent = {
		enable = true
	},
	-- context commetstring setup
	-- source: https://github.com/JoosepAlviste/nvim-ts-context-commentstring#commentnvim
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
})

