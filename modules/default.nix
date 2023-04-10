{ pkgs, ... }: {

  imports = [
    ./gnome.nix
    ./packages.nix
    ./network.nix
    ./user.nix
  ];
}

