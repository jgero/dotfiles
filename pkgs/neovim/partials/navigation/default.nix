{ pkgs, readAll }: {
  name = "navigation";
  dependencies = with pkgs; [ ripgrep fzf fd ];
  plugins = with pkgs.vimPlugins; [
    oil-nvim
    plenary-nvim
    telescope-nvim
    telescope-fzf-native-nvim
  ];
  config = readAll [ ./oil.lua ./telescope.lua ];
}
