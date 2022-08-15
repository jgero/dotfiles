{ config, pkgs, ... }: {
  imports = [
    ./scripts.nix
  ];
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
      # bind ctrl-f to the tmux session switcher
      bindkey -s '^f' 'selectProject\n'
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
