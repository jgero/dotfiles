{ pkgs, pkgs-unstable, ... }:
let
  genLspConfig = name: cmd: extraConfig: ''
    vim.lsp.config("${name}", {
      cmd = use_exec_or_fallback("${builtins.baseNameOf (builtins.elemAt cmd 0)}", ${
        builtins.concatStringsSep ", " (map (v: ''"${v}"'') cmd)
      }),
      ${extraConfig}
    })
    vim.lsp.enable("${name}")
  '';
in
(
  (builtins.readFile ./lsp-config.lua)
    + (builtins.concatStringsSep "\n" ([
    (genLspConfig "nil_ls" [ "${pkgs.nil}/bin/nil" ] "")
    (genLspConfig "lua_ls" [ "${pkgs.lua-language-server}/bin/lua-language-server" ] ''
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
    '')
    (genLspConfig "bashls" [ "${pkgs.bash-language-server}/bin/bash-language-server" "start" ] "")
    (genLspConfig "clangd" [ "${pkgs.clang-tools}/bin/clangd" ] "")
    (genLspConfig "html" [
      "${pkgs.vscode-langservers-extracted}/bin/vscode-html-language-server"
      "--stdio"
    ] "")
    (genLspConfig "cssls" [
      "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server"
      "--stdio"
    ] "")
    (genLspConfig "jsonls" [
      "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server"
      "--stdio"
    ] "")
    (genLspConfig "ts_ls" [
      "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server"
      "--stdio"
    ] "")
    (genLspConfig "rust_analyzer" [ "${pkgs.rust-analyzer}/bin/rust-analyzer" ] ''
      	settings = {
      		['rust-analyzer'] = {
      			cargo = {
      				features = "all"
      			}
      		}
      	},
    '')
    (genLspConfig "gopls" [ "${pkgs.gopls}/bin/gopls" ] "")
    (genLspConfig "templ" [ "${pkgs.templ}/bin/templ" "lsp" ] "")
    (genLspConfig "golangci_lint_ls" [
      "${pkgs-unstable.golangci-lint-langserver}/bin/golangci-lint-langserver"
    ] "")
    (genLspConfig "postgres_lsp" [
      "${pkgs-unstable.postgres-language-server}/bin/postgres-language-server"
      "lsp-proxy"
    ] "")
    (genLspConfig "helm_ls" [ "${pkgs.helm-ls}/bin/helm_ls" "serve" ] "")
    (genLspConfig "terraformls" [ "${pkgs.terraform-ls}/bin/terraform-ls" "serve" ] "")
    (genLspConfig "yamlls" [ "${pkgs.yaml-language-server}/bin/yaml-language-server" "--stdio" ] "")
  ]))
)
