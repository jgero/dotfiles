{ pkgs }:

let
  plugins = pkgs.vimPlugins;
  readAll = import ../lib/readAndAppend.nix;
in
[
  (import ./builtins { inherit readAll pkgs; })
  {
    name = "essentials";
    plugins = with plugins; [ comment-nvim vim-surround vim-repeat ];
    config = ''require("Comment").setup({})'';
  }
  (import ./languages { inherit readAll pkgs; })
  (import ./git { inherit readAll pkgs; })
  (import ./navigation { inherit readAll pkgs; })
  {
    name = "theme";
    plugins = [ plugins.onedark-nvim plugins.transparent-nvim ];
    config = ''
      require("onedark").setup({
        style = "darker",
      })
      require("onedark").load()
      require("transparent").setup()

      vim.g.transparent_enabled = true
    '';
  }
  {
    name = "undo";
    plugins = [ plugins.undotree ];
    config = ''vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "toggle [u]ndo tree" })'';
  }
  (import ./tabset.nix { inherit pkgs; })
]
