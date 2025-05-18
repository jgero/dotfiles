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
  aiModel = builtins.fetchurl {
    url = "https://huggingface.co/ggml-org/Qwen2.5-Coder-1.5B-Q8_0-GGUF/resolve/main/qwen2.5-coder-1.5b-q8_0.gguf?download=true";
    sha256 = "0ci8lcnsy8qsyh5q0pjv46k2brja7l8kg6pp8giac9sps6a1r1r9";
  }; 
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
    rec {
      name = withPrefix "ai";
      sources = ./ai;
      plugins = with pkgs.vimPlugins; [ minuet-ai-nvim plenary-nvim ];
      init = ''
        ${generateRequire name "minuet"}
        local serve = ${generateRequire name "llm_serving"}
        serve.setup({
          command = "${pkgs.llama-cpp}/bin/llama-server",
          model_path = "${aiModel}",
        })
      '';
    }
    (import ./tabset.nix { inherit pkgs withPrefix; })
    {
      name = withPrefix "ui";
      order = 1;
      plugins = [ plugins.fidget-nvim ];
      init = ''require("fidget").setup({})'';
    }
  ]
