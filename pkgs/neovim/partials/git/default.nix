{ pkgs, readAll }: {
  name = "git";
  plugins = with pkgs.vimPlugins; [
    vim-fugitive
    gitsigns-nvim
  ];
  config = readAll [ ./fugitive.lua ./gitsigns.lua ];
}
