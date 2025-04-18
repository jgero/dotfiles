-- keymap leader
vim.g.mapleader = " "
-- render whitespaces
vim.o.list = true
vim.o.listchars = "tab:» ,lead:·,trail:·,eol:¬,extends:…"
-- line numbers
vim.o.nu = true
vim.o.relativenumber = true
-- indent config
-- vim.o.tabstop = 4
-- vim.o.softtabstop = 4
-- vim.o.shiftwidth = 4
-- vim.o.expandtab = true
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "*.lua", "*.go" },
-- 	callback = function()
-- 		vim.opt_local.expandtab = false
-- 		vim.opt_local.softtabstop = 0
-- 	end,
-- })
-- vim.o.smartindent = true
vim.o.wrap = false
vim.o.colorcolumn = "80"
vim.o.textwidth = 80 -- enable re-arranging lines with gq
vim.o.formatoptions = "cqj" -- no auto formatting for text
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*.tex", "*.md" },
	callback = function()
		vim.opt_local.formatoptions = "tcqj" -- auto formatting for text as well
	end,
})
-- history
vim.o.backup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("data") .. "/undodir"
-- visuals
vim.o.termguicolors = true -- is also set automatically by some themes
vim.o.signcolumn = "yes:5" -- give plenty of space for signs
vim.o.cmdheight = 2
vim.o.scrolloff = 8 -- don't let cursor get too close to the edge
-- performance
vim.o.updatetime = 50
vim.o.hidden = true -- keep hidden buffers
-- searching
vim.o.ignorecase = true
vim.o.smartcase = true
-- splits: by default split to right and below
vim.o.splitright = true
vim.o.splitbelow = true
