{ pkgs, ... }: {
  programs.zsh =
    let
      select-project = import ../../pkgs/select-project.nix { inherit pkgs; };
    in
    {
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
        sp = ''${select-project}/bin/select-project'';
      };
      initExtra = ''
        ${builtins.readFile ./prompt.zsh}
        # bind ctrl-f to the tmux session switcher
        bindkey -s '^f' 'sp^M'
        # bind ctrl-h to reverse history search
        bindkey '^h' history-incremental-pattern-search-backward
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
