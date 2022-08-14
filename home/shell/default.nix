{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    dirHashes = {
      gitdir = "$HOME/git";
    };
    sessionVariables = {
      FZF_BASE = "{pkgs.fzf}";
    };
	initExtra = ''
    ${builtins.readFile ./prompt.zsh}
	'';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "fzf"
        "taskwarrior"
      ];
    };
  };
}
