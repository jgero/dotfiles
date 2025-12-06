{ pkgs, pkgs-unstable, ... }: ''
  local function use_exec_or_fallback(exec, fallback, ...)
    local cmd = {}
    if vim.fn.executable(exec) == 1 then
      table.insert(cmd, exec)
    else
      table.insert(cmd, fallback)
    end
    for _, arg in ipairs({...}) do
      table.insert(cmd, arg)
    end
    return cmd
  end
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      local nmap = function(keys, func, desc)
        if desc then
          desc = "LSP: " .. desc
        end
        vim.keymap.set("n", keys, func, { buffer = args.buf, desc = desc })
      end
      -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
      if client:supports_method('textDocument/completion') then
        -- Optional: trigger autocompletion on EVERY keypress. May be slow!
        -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
        -- client.server_capabilities.completionProvider.triggerCharacters = chars

        vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
      end
      -- TODO: check if client supports method (client:supports_method) before creating keybindings
      nmap("gd", vim.lsp.buf.definition, "[g]o to [d]efinition")
      nmap("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
      nmap("<leader>d", vim.lsp.buf.signature_help, "show signature help [d]ocumentation")
      nmap("<leader>df", vim.diagnostic.open_float, "show [d]iagnostics [f]loat")
      nmap("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ctions")
      nmap("H", vim.lsp.buf.hover, "[H]over")
      nmap("<leader>lf", vim.lsp.buf.format, "[l]sp do [f]ormatting")
    end
  })
  vim.lsp.config('*', {
    capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    root_markers = { '.git' },
  })
  vim.lsp.config.lua_ls = {
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME
          },
        },
        telemetry = { enable = false },
      },
    },
    cmd = use_exec_or_fallback("lua-language-server", "${pkgs.lua-language-server}/bin/lua-language-server"),
  }
  vim.lsp.config.nil_ls = {
    cmd = use_exec_or_fallback("nil", "${pkgs.nil}/bin/nil"),
  }
  vim.lsp.config.bashls = {
    cmd = use_exec_or_fallback("bash-language-server", "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start"),
  }
  vim.lsp.config.clangd = {
    cmd = use_exec_or_fallback("clangd", "${pkgs.clang-tools}/bin/clangd"),
  }
  vim.lsp.config.html = {
    cmd = use_exec_or_fallback("vscode-html-language-server", "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio"),
  }
  vim.lsp.config.cssls = {
    cmd = use_exec_or_fallback("vscode-css-language-server", "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio"),
  }
  vim.lsp.config.jsonls = {
    cmd = use_exec_or_fallback("vscode-json-language-server", "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server", "--stdio"),
  }
  vim.lsp.config.ts_ls = {
    cmd = use_exec_or_fallback("typescript-language-server", "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio"),
  }
  vim.lsp.config.rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          features = "all"
        }
      }
    },
    cmd = use_exec_or_fallback("rust-analyzer", "${pkgs.rust-analyzer}/bin/rust-analyzer"),
  }
  vim.lsp.config.gopls = {
    cmd = use_exec_or_fallback("gopls", "${pkgs.gopls}/bin/gopls"),
  }
  vim.lsp.config.templ = {
    cmd = use_exec_or_fallback("templ", "${pkgs.templ}/bin/templ", "lsp"),
  }
  vim.lsp.config.golangci_lint_ls = {
    cmd = use_exec_or_fallback("golangci-lint-langserver", "${pkgs-unstable.golangci-lint-langserver}/bin/golangci-lint-langserver"),
    init_options = {
      command = { "${pkgs-unstable.golangci-lint}/bin/golangci-lint", "run", "--output.json.path", "stdout", "--show-stats=false", "--issues-exit-code=1" },
    },
  }
''
