{ osConfig, ... }: ''
  vim.env.SRC_ENDPOINT = "https://sourcegraph.com"
  vim.env.SRC_ACCESS_TOKEN = vim.fn.readfile("${osConfig.age.secrets.sgAccessToken.path}")[1]
  require("sg.auth").get()

  local sg = require("sg")

  sg.setup {
  	enable_cody = true,
  	accept_tos = true
  }

  local cody = require("sg.cody.commands")

  local map = function(mode, keys, func, desc)
  	if desc then
  		desc = "CODY: " .. desc
  	end
  	vim.keymap.set(mode, keys, func, { desc = desc })
  end

  map("v", "<leader>ar", function ()
  	local idxes = vim.fn.sort({vim.api.nvim_win_get_cursor(0)[1], vim.fn.line("v")})
  	local message = vim.fn.input("Enter message for Cody: ")
  	cody.ask_range(vim.api.nvim_get_current_buf(), idxes[1] - 1, idxes[2], message)
  end, "[a]sk cody on a [r]ange of lines")
''
