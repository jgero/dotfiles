{ pkgs, ... }: {
  programs.bash =
    let
      select-project = import ../pkgs/select-project.nix { inherit pkgs; };
    in
    {
      enable = true;
      shellAliases = {
        ptask = "task project:$(git rev-parse --show-toplevel | xargs basename)";
        compress10 = "mogrify -quality 10";
        addK = "ssh-add -K";
        sp = ''${select-project}/bin/select-project'';
        udm = "udisksctl mount -b";
      };
      initExtra = ''
        # bind ctrl-f to the tmux session switcher
        bind -x '"\C-f":sp'
      '';
    };
}
