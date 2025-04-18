{ pkgs, ... }: ''
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
  local on_attach = function(client, bufnr)
    local nmap = function(keys, func, desc)
      if desc then
        desc = "LSP: " .. desc
      end
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    if client.server_capabilities.documentFormattingProvider then
      nmap("<leader>lf", vim.lsp.buf.format, "[l]sp do [f]ormatting")
    end

    nmap("gd", vim.lsp.buf.definition, "[g]o to [d]efinition")
    nmap("<leader>rn", vim.lsp.buf.rename, "[r]e[n]ame")
    nmap("<leader>d", vim.lsp.buf.signature_help, "show signature help [d]ocumentation")
    nmap("<leader>df", vim.diagnostic.open_float, "show [d]iagnostics [f]loat")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[c]ode [a]ctions")
    nmap("H", vim.lsp.buf.hover, "[H]over")
  end
  local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
  local lspc = require("lspconfig")
  lspc.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
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
    cmd = use_exec_or_fallback("lua-language-server", "${pkgs.sumneko-lua-language-server}/bin/lua-language-server"),
  })
  lspc.nil_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = use_exec_or_fallback("nil", "${pkgs.nil}/bin/nil"),
  })
  lspc.bashls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = use_exec_or_fallback("bash-language-server", "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server", "start"),
  })
  lspc.clangd.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = use_exec_or_fallback("clangd", "${pkgs.clang-tools}/bin/clangd"),
  })
  lspc.html.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = use_exec_or_fallback("vscode-html-language-server", "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server", "--stdio"),
  })
  lspc.cssls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = use_exec_or_fallback("vscode-css-language-server", "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio"),
  })
  lspc.jsonls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = use_exec_or_fallback("vscode-json-language-server", "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server", "--stdio"),
  })
  lspc.ts_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = use_exec_or_fallback("typescript-language-server", "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio"),

  })
  lspc.rust_analyzer.setup({
    settings = {
      ['rust-analyzer'] = {
        cargo = {
          features = "all"
        }
      }
    },
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = use_exec_or_fallback("rust-analyzer", "${pkgs.rust-analyzer}/bin/rust-analyzer"),
  })
  lspc.gopls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = use_exec_or_fallback("gopls", "${pkgs.gopls}/bin/gopls"),
  })
  lspc.templ.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = use_exec_or_fallback("templ", "${pkgs.templ}/bin/templ", "lsp"),
  })
''
