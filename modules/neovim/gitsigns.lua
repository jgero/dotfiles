require('gitsigns').setup({
	numhl = true,
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns
		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- navigation
		map('n', '<leader>ghn', function()
			if vim.wo.diff then
				return ']c'
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return '<Ignore>'
		end, { expr = true })

		map('n', '<leader>ghp', function()
			if vim.wo.diff then
				return '[c'
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return '<Ignore>'
		end, { expr = true })

		-- Actions
		map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>')
		map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>')
		map('n', '<leader>ghS', gs.stage_buffer)
		map('n', '<leader>ghu', gs.undo_stage_hunk)
		map('n', '<leader>ghR', gs.reset_buffer)
		map('n', '<leader>ghP', gs.preview_hunk)
		map('n', '<leader>ghb', function()
			gs.blame_line({ full = true })
		end)
		map('n', '<leader>gtb', gs.toggle_current_line_blame)
		map('n', '<leader>ghd', gs.diffthis)
		map('n', '<leader>ghD', function()
			gs.diffthis('~')
		end)
		map('n', '<leader>gtd', gs.toggle_deleted)
	end,
})
