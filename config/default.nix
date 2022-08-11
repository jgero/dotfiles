{ inputs, pkgs, ... }: {
  home.stateVersion = "22.05";
  xdg.enable = true;

  imports = [
    ./packages.nix
    ./shell.nix
    ./neovim
    ./terminal.nix
    ./git.nix
    ./ssh.nix
  ];
}
