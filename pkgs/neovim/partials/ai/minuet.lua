local max_tokens = 25

require('minuet').setup {
	notify = 'warn',
	request_timeout = 10,
	provider = 'openai_fim_compatible',
	n_completions = 1,
	context_window = 512,
	provider_options = {
		openai_fim_compatible = {
			api_key = 'TERM',
			name = 'Llama.cpp',
			stream = true,
			end_point = 'http://localhost:8012/v1/completions',
			-- The model is set by the llama-cpp server and cannot be altered
			-- post-launch.
			model = 'PLACEHOLDER',
			optional = {
				max_tokens = max_tokens,
				top_p = 0.9,
			},
			-- Llama.cpp does not support the `suffix` option in FIM completion.
			-- Therefore, we must disable it and manually populate the special
			-- tokens required for FIM completion.
			template = {
				prompt = function(context_before_cursor, context_after_cursor, _)
					return '<|fim_prefix|>'
						.. context_before_cursor
						.. '<|fim_suffix|>'
						.. context_after_cursor
						.. '<|fim_middle|>'
				end,
				suffix = false,
			},
			get_text_fn = {
				stream = function(json)
					return json.choices[1].text
				end,
			},
		},
	},
}

local progress = require("fidget.progress")
local requests = {}

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "MinuetRequestStarted",
	callback = function(event)
		requests[event.data.request_idx or 1] = progress.handle.create({
			title = "AI completion",
			message = "generating...",
			lsp_client = { name = "minuet" },
			percentage = 0,
		})
	end,
})

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "MinuetRequestFinished",
	callback = function(event)
		requests[event.data.request_idx or 1]:finish()
	end
})
