{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.jetbrains-mono;
      name = "JetBrains Mono";
      size = 14;
    };
    settings = {
      enable_audio_bell = false;
    };
  };
}

