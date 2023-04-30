{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    dirHashes = {
      gitdir = "$HOME/git";
    };
    sessionVariables = {
      GIT_EDITOR = "nix run ~/projects/init.lua --";
    };
    shellAliases = {
      ptask = "task project:$(git rev-parse --show-toplevel | xargs basename)";
      nvim = "nix run ~/projects/init.lua --";
      compress10 = "mogrify -quality 10";
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
