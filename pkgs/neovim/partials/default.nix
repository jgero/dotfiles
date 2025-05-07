{ pkgs, lib }:

let
  plugins = pkgs.vimPlugins;
  withPrefix = val: "jgero-pack-${val}";
  generateRequire = package: file: ''require("${package}.${file}")'';
  getAllModules = dir: builtins.filter (f: !(lib.strings.hasSuffix ".nix" f)) (lib.attrsets.mapAttrsToList
    (name: value:
      if lib.strings.hasSuffix ".lua" name then
        lib.strings.removeSuffix ".lua" name else name)
    (builtins.readDir dir));
  requireAllModules = name: sources: builtins.concatStringsSep "\n" (map (p: generateRequire name p) (getAllModules sources));
  mkPack = import ../lib/mkPack.nix pkgs;
in
map mkPack
  [
    rec {
      name = withPrefix "options";
      order = 0;
      sources = ./builtins;
      init = requireAllModules name sources;
      dependencies = [ pkgs.nodejs_22 (import ./builtins/spellfiles.nix pkgs) ];
    }
    {
      name = withPrefix "essentials";
      init = ''require("Comment").setup({})'';
      plugins = with plugins; [ comment-nvim vim-surround vim-repeat ];
    }
    rec {
      name = withPrefix "languages";
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
      sources = ./languages;
      init = (requireAllModules name sources) + (import ./languages/nvim-lspconfig.lua.nix { inherit pkgs; });
    }
    rec {
      name = withPrefix "git";
      plugins = with pkgs.vimPlugins; [ vim-fugitive gitsigns-nvim ];
      sources = ./git;
      init = requireAllModules name sources;
    }
    rec {
      name = withPrefix "navigation";
      dependencies = with pkgs; [ ripgrep fzf fd ];
      plugins = with pkgs.vimPlugins; [
        oil-nvim
        plenary-nvim
        telescope-nvim
        telescope-fzf-native-nvim
      ];
      sources = ./navigation;
      init = requireAllModules name sources;
    }
    {
      name = withPrefix "theme";
      plugins = [ plugins.onedark-nvim plugins.transparent-nvim ];
      init = ''
        require("onedark").setup({
          style = "darker",
        })
        require("onedark").load()
        require("transparent").setup()

        vim.g.transparent_enabled = true
      '';
    }
    {
      name = withPrefix "undo";
      plugins = [ plugins.undotree ];
      init = ''vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "toggle [u]ndo tree" })'';
    }
    (import ./tabset.nix { inherit pkgs withPrefix; })
    {
      name = withPrefix "ui";
      order = 1;
      plugins = [ plugins.fidget-nvim ];
      init = ''require("fidget").setup({})'';
    }
  ]
