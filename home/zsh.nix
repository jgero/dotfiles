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
      nvimStable = "nix run github:jgero/init.lua/stable --";
      compress10 = "mogrify -quality 10";
      addK = "ssh-add -K";
      createDevProfile = ''nix develop --profile "$XDG_DATA_HOME/dev-profile-$(git rev-parse --show-toplevel | xargs basename)"'';
      dev = ''nix develop "$XDG_DATA_HOME/dev-profile-$(git rev-parse --show-toplevel | xargs basename)"'';
      hyprlandLogs = ''cat /tmp/hypr/$(ls -t /tmp/hypr/ | head -n 1)/hyprland.log'';
    };
    initExtra = ''
      ${builtins.readFile ../scripts/zsh/prompt.zsh}
      # bind ctrl-f to the tmux session switcher
      bindkey -s '^f' 'selectProject\n'
      # start ssh agent to allow importing resident key
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
