require("gitsigns").setup({
	on_attach = function(bufnr)
		local nmap = function(keys, func, desc, expr)
			if desc then
				desc = "[g]it [h]unk " .. desc
			end
			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, expr = expr })
		end
		local gs = package.loaded.gitsigns
		nmap("<leader>ghn", function()
			-- do nothing in diff
			if vim.wo.diff then
				return "<leader>ghn"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, "go to [n]ext", true)
		nmap("<leader>ghp", function()
			-- do nothing in diff
			if vim.wo.diff then
				return "<leader>ghp"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, "go to [p]revious", true)
		nmap("<leader>ghs", function()
			vim.cmd([[Gitsigns stage_hunk]])
		end, "[s]tage", false)
		nmap("<leader>ghu", gs.undo_stage_hunk, "[u]nstage", false)
		nmap("<leader>ghr", function()
			vim.cmd([[Gitsigns reset_hunk]])
		end, "[r]eset", false)
		nmap("<leader>ghb", function()
			gs.blame_line({ full = true })
		end, "[b]lame", false)
		nmap("<leader>ghd", function()
			gs.diffthis(nil, { split = "belowright" })
		end, "[d]iff", false)
	end,
})
