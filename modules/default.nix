{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    neovim
    curl
    restic
  ];

  imports = [
    ./backup.nix
    ./containers.nix
    ./gnome.nix
    ./impermanence.nix
    ./network.nix
    ./nix.nix
    ./sudo.nix
    ./user.nix
  ];
}

