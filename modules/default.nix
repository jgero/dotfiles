{ pkgs, ... }: {

  imports = [
    ./gnome.nix
    ./impermanence.nix
    ./network.nix
    ./nix.nix
    ./packages.nix
    ./user.nix
  ];
}

