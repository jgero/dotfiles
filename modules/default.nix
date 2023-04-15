{ pkgs, ... }: {

  imports = [
    ./gnome.nix
    ./impermanence.nix
    ./network.nix
    ./packages.nix
    ./user.nix
  ];
}

