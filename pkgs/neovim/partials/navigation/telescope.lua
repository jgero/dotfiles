local telescope = require("telescope")

telescope.setup({
	defaults = {
		-- Format path as "file.txt (path/to/file/)"
		path_display = function(opts, path)
			local tail = require("telescope.utils").path_tail(path)
			return string.format("%s (%s)", tail, path)
		end,
	},
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[f]ind [f]files" })
vim.keymap.set("n", "<leader>fn", function()
	builtin.find_files({
		search_dirs = { "/home/jgero/data/notes" },
	})
end, { desc = "[f]ind in [n]otes" })
vim.keymap.set("n", "<leader>fd", function()
	builtin.find_files({
		search_dirs = { "/home/jgero/.config/nvim" },
	})
end, { desc = "[f]ind in neovim [d]otfiles" })

vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "[f]ind [g]it files" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[f]ind [h]elp tags" })
vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "[f]ind [w]ord (global)" })
vim.keymap.set("n", "<leader>f/", builtin.current_buffer_fuzzy_find, { desc = "[f]ind in curren buffer (like with /)" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[f]ind [k]eymaps" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "[f]ind LSP [r]eferences" })
vim.keymap.set("n", "<leader>fv", builtin.lsp_document_symbols, { desc = "[f]ind LSP document symbols ([v]ariables)" })
vim.keymap.set("n", "<leader>fc", builtin.lsp_workspace_symbols, { desc = "[f]ind LSP workspace symbols ([c]lasses)" })
vim.keymap.set("n", "<leader>fm", function()
	builtin.man_pages({ sections = { "1", "2", "3", "4", "5", "6", "7", "8", "9" } })
end, { desc = "[f]ind [m]anpages" })
