local utils = {}

local scopes = { o = vim.o, b = vim.bo, w = vim.wo }

function utils.opt(scope, key, value)
	scopes[scope][key] = value
	if scope ~= 'o' then
		scopes['o'][key] = value
	end
end

function utils.map(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend('force', options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- render whitespaces
utils.opt('o', 'list', true)
utils.opt('o', 'listchars', 'tab:» ,lead:·,trail:·')

-- tab management
utils.opt('b', 'tabstop', 4)
utils.opt('b', 'shiftwidth', 4)

-- auto source vimrc from project dirs if they exist
utils.opt('o', 'exrc', true)

-- line numbers
utils.opt('w', 'number', true)
utils.opt('w', 'relativenumber', true)

-- nomally ignore case but do not ignore case when search is in uppercase
utils.opt('o', 'ignorecase', true)
utils.opt('o', 'smartcase', true)

-- keep buffers open
utils.opt('o', 'hidden', true)

utils.opt('w', 'wrap', false)
utils.opt('w', 'colorcolumn', '100')
-- this enables breaking lines with 'gq'
utils.opt('b', 'textwidth', 100)

-- history
utils.opt('o', 'backup', false)
utils.opt('o', 'swapfile', false)
utils.opt('o', 'undofile', true)

-- scrolling before cursor reaches the end
utils.opt('o', 'scrolloff', 8)

utils.opt('o', 'updatetime', 50)
utils.opt('o', 'completeopt', 'menu,menuone,noselect')
utils.opt('o', 'cmdheight', 2)

-- set splitting direction
utils.opt('o', 'splitright', true)
utils.opt('o', 'splitbelow', true)

-- set spellcheck for some files
vim.o.spelllang = 'en_us,de_de'
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
	callback = function()
		if vim.bo.filetype == 'markdown'
		    or vim.bo.filetype == 'gitcommit'
		    or vim.bo.filetype == 'tex'
		then
			vim.opt_local.spell = true
		end
	end,
})

vim.o.termguicolors = true

-- set leader key
vim.g.mapleader = ' '

---------------------------------------------------------------------------------------------------
-- general

-- resize buffer
utils.map('n', '<leader>+', ':resize +1<cr>')
utils.map('n', '<leader>-', ':resize -1<cr>')

-- select project command in harpoon managed terminal
utils.map(
	'n',
	'<C-f>',
	':lua require("harpoon.term").sendCommand(4, "selectProject\\n"); require("harpoon.term").gotoTerminal(4)<CR>'
)

-- copy to clipboard
utils.map('v', '<leader>y', '"+y')
-- paste from clipboard
utils.map('n', '<leader>p', '"+p')
utils.map('n', '<leader>P', '"+P')
utils.map('v', '<leader>p', '"+p')
utils.map('v', '<leader>P', '"+P')

-- reset search highlight on enter press in normal mode
utils.map('n', '<CR>', '{ -> v:hlsearch ? ":nohl\\<CR>" : "\\<CR>" }()', { expr = true })

-- exit terminal mode with escape
utils.map('t', '<Esc>', '<C-\\><C-n>')
-- open new terminal on the bottom
utils.map('', '<leader>t', ':split term://zsh<cr>')

---------------------------------------------------------------------------------------------------
-- Telescope

-- find files in current working dir
utils.map('n', '<Leader>ff', ':lua require(\'telescope.builtin\').find_files()<CR>')
-- find GIT files in current working dir
utils.map('n', '<Leader>fg', ':lua require(\'telescope.builtin\').git_files()<CR>')
-- find words
utils.map('n', '<leader>fw', ':lua require(\'telescope.builtin\').live_grep()<cr>')
-- find in current buffers
utils.map('n', '<leader>fb', ':lua require(\'telescope.builtin\').buffers()<cr>')
-- find in help tags
utils.map('n', '<leader>fh', ':lua require(\'telescope.builtin\').help_tags()<cr>')
-- find files in notes
utils.map(
	'n',
	'<Leader>fn',
	':lua require(\'telescope.builtin\').find_files({ search_dirs = { \'/home/jgero/sync/notes\' } })<CR>'
)
-- find in (notification) messages
utils.map('n', '<leader>fm', ':lua require(\'telescope\').extensions.notify.notify()<cr>')
-- find files in dotfiles
utils.map(
	'n',
	'<Leader>fd',
	':lua require(\'telescope.builtin\').find_files({ search_dirs = { \'/home/jgero/repos/dotfiles\' } })<CR>'
)
-- find in document symbols (this is insanely nice)
utils.map('n', '<Leader>fs', ':lua require(\'telescope.builtin\').lsp_document_symbols()<CR>')

---------------------------------------------------------------------------------------------------
-- Harpoon

-- mark file
utils.map('n', '<leader>hm', ':lua require(\'harpoon.mark\').add_file()<CR>')

-- toggle menu
utils.map('n', '<leader>hl', ':lua require("harpoon.ui").toggle_quick_menu()<CR>')

-- nav to file 1-4
utils.map('n', '<leader>ha', ':lua require("harpoon.ui").nav_file(1)<CR>')
utils.map('n', '<leader>hs', ':lua require("harpoon.ui").nav_file(2)<CR>')
utils.map('n', '<leader>hd', ':lua require("harpoon.ui").nav_file(3)<CR>')
utils.map('n', '<leader>hf', ':lua require("harpoon.ui").nav_file(4)<CR>')

-- nav to terminals 1-2
utils.map('n', '<leader>hta', ':lua require("harpoon.term").gotoTerminal(1)<CR>')
utils.map('n', '<leader>hts', ':lua require("harpoon.term").gotoTerminal(2)<CR>')
