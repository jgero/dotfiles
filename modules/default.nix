{ pkgs, ... }: {

  imports = [
    ./gnome.nix
    ./impermanence.nix
    ./network.nix
    ./nix.nix
    ./packages.nix
    ./sudo.nix
    ./user.nix
  ];
}

