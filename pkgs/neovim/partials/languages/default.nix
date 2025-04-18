{ pkgs, readAll }: {
  name = "languages";

  plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars

    nvim-lspconfig
    nvim-cmp
    cmp-nvim-lsp
    cmp-buffer
    cmp-path
    cmp-cmdline
    luasnip
    cmp_luasnip
    friendly-snippets
    lsp_lines-nvim
  ];
  config = readAll [ ./cmp.lua ./lsp-lines.lua ./treesitter.lua ] + (import ./nvim-lspconfig.lua.nix pkgs);
}
