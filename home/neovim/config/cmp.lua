local cmp = require("cmp")
local ls = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			ls.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
		["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
		["<CR>"] = cmp.mapping.confirm(),
	},
	sources = cmp.config.sources({
		{ name = "cody" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "treesitter" },
	}, {
		{ name = "buffer" },
	}),
})
cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

vim.keymap.set({ "i", "s" }, "<C-L>", function()
	ls.jump(1)
end, { silent = true, desc = "jump forwards in snippet" })

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("go", {
	s("iferr", {
		t({ "if " }),
		i(1, "err != nil"),
		t({ " {", "\treturn " }),
		i(2, "err"),
		t({ "", "}", "" }),
		i(0),
	}),
})
