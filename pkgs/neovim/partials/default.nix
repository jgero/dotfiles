{ pkgs, pkgs-unstable, lib }:

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
  qwen2_5 = builtins.fetchurl {
    url = "https://huggingface.co/ggml-org/Qwen2.5-Coder-1.5B-Q8_0-GGUF/resolve/main/qwen2.5-coder-1.5b-q8_0.gguf?download=true";
    sha256 = "0ci8lcnsy8qsyh5q0pjv46k2brja7l8kg6pp8giac9sps6a1r1r9";
  };
  # starcoder2 = builtins.fetchurl {
  #   url = "https://huggingface.co/second-state/StarCoder2-3B-GGUF/resolve/main/starcoder2-3b-Q5_K_S.gguf?download=true";
  #   sha256 = "1h00c7ajz1y8sali3jyrq1a2cdqr4sjishr37zjmv3r21bcc0ka8";
  # };
  # codellama = builtins.fetchurl {
  #   url = "https://huggingface.co/TheBloke/CodeLlama-7B-GGUF/resolve/main/codellama-7b.Q2_K.gguf?download=true";
  #   sha256 = "1xczbvh08r35wpfjljbr4bhalnjij6692rgj98hs84i9vw0m1jfk";
  # };
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

        helm-ls-nvim
      ];
      sources = ./languages;
      init = (requireAllModules name sources) + (import ./lsp-config { inherit pkgs pkgs-unstable; });
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
      plugins = with plugins; [ onedark-nvim lualine-nvim vim-tpipeline ];
      init = ''
        require("onedark").setup({
          style = "darker",
        })
        require("onedark").load()
        if os.getenv("TMUX") then
          vim.defer_fn(function()
            vim.o.laststatus = 0
          end, 0)
        end
        require("lualine").setup({ options = { theme = "onedark" } })
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
      plugins = with pkgs.vimPlugins; [ minuet-ai-nvim ];
      init = ''
        ${generateRequire name "minuet"}
        local serve = ${generateRequire name "llm_serving"}
        serve.setup({
          command = "${pkgs.llama-cpp}/bin/llama-server",
          model_path = "${qwen2_5}",
        })
      '';
      opt = true;
    }
    (import ./tabset.nix { inherit pkgs withPrefix; })
    {
      name = withPrefix "ui";
      order = 1;
      plugins = [ plugins.fidget-nvim ];
      init = ''
        require("fidget").setup({ notification = { override_vim_notify = true } })
      '';
    }
    {
      name = withPrefix "testing-debugging";
      plugins = with plugins; [ neotest neotest-golang ];
      init = ''
        local neotest = require("neotest")
        neotest.setup({
          adapters = {
            require("neotest-golang")({
              go_test_args = { "-v", "-count=1" },
            })
          },
        })
        vim.keymap.set("n", "<leader>tn", function() neotest.run.run() end, { desc = "run the [t]est that is [n]erarest" })
        vim.keymap.set("n", "<leader>ts", function() neotest.summary.toggle() end, { desc = "toggle the [t]est [s]ummary" })
        vim.keymap.set("n", "<leader>to", function() neotest.output.open() end, { desc = "show [t]est [o]utput" })
      '';
    }
  ]
