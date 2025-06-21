{ pkgs, hideBorder, background, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.jetbrains-mono;
      name = "JetBrains Mono";
      size = 14;
    };
    settings = {
      enable_audio_bell = false;
      tab_bar_style = "hidden";
      hide_window_decorations = hideBorder;
      background = background;
      background_opacity = "0.89";
    };
  };
}
