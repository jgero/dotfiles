{ config, pkgs, ... }: {
  programs.alacritty = {
    enable = true;
	settings = {
	  font = {
        normal.family = "JetBrains Mono";
        bold.family = "JetBrains Mono";
        italic.family = "JetBrains Mono";
        bold_italic.family = "JetBrains Mono";
      };
    };
  };
}

