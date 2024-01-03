{ pkgs, ... }: {
  programs.zsh =
    let
      select-project = import ../pkgs/select-project.nix { inherit pkgs; };
    in
    {
      enable = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ptask = "task project:$(git rev-parse --show-toplevel | xargs basename)";
        compress10 = "mogrify -quality 10";
        addK = "ssh-add -K";
        sp = ''${select-project}/bin/select-project'';
        udm = "udisksctl mount -b";
      };
      initExtra = ''
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
