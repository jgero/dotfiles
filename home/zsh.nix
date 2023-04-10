{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    dirHashes = {
      gitdir = "$HOME/git";
    };
    sessionVariables = {
      FZF_BASE = "{pkgs.fzf}";
      GIT_EDITOR = "nvim";
    };
    shellAliases = {
      addptask = "task add project:$(git rev-parse --show-toplevel | xargs basename)";
      ptask = "task project:$(git rev-parse --show-toplevel | xargs basename)";
    };
    initExtra = ''
      ${builtins.readFile ../scripts/zsh/prompt.zsh}
      # bind ctrl-f to the tmux session switcher
      bindkey -s '^f' 'selectProject\n'
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [
        "fzf"
        "taskwarrior"
        "systemd"
      ];
    };
  };
}
