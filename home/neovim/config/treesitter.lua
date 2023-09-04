require("nvim-treesitter.configs").setup({
	parser_install_dir = "$XDG_DATA_HOME/nvim/site",
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
	},
	-- context commetstring setup
	-- source: https://github.com/JoosepAlviste/nvim-ts-context-commentstring#commentnvim
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
})
