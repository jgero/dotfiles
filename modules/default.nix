{ pkgs, ... }: {

  imports = [
    ./bluetooth.nix
    ./gnome.nix
    ./packages.nix
    ./network.nix
    ./user.nix
  ];
}

