local cmp = require('cmp')
local luasnip = require('luasnip')
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
		['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
		['<C-y>'] = cmp.config.disable,
		['<C-e>'] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping(function(fallback)
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
								else
								fallback()
			end
		end, { 'i', 's' }),

		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
		{ name = 'treesitter' },
	}, {
		{ name = 'buffer' },
	}),
})

cmp.setup.cmdline('/', {
	sources = {
		{ name = 'buffer' },
	},
})

cmp.setup.cmdline(':', {
	sources = cmp.config.sources({
		{ name = 'path' },
	}, {
		{ name = 'cmdline' },
	}),
})

local diagnostics_active = true
vim.keymap.set('n', '<leader>d', function()
	diagnostics_active = not diagnostics_active
	if diagnostics_active then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end)
