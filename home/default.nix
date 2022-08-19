{ inputs, pkgs, ... }: {
  home.stateVersion = "22.05";
  xdg.enable = true;

  imports = [
    ./packages.nix
    ./neovim
    ./terminal.nix
    ./git.nix
    ./ssh.nix
    ./task.nix
    ./shell
    ./tmux.nix
    ./gnome_dconf.nix
  ];
}
