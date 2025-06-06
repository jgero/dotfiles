{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    curl
    udisks
    btop
    neovim
  ];

  services.udisks2.enable = true;

  documentation.man = {
    enable = true;
    generateCaches = true;
  };

  imports = [
    ./backup.nix
    ./bluetooth.nix
    ./boot.nix
    ./firmware.nix
    ./i18n.nix
    ./network.nix
    ./nix.nix
    ./packages.nix
    ./secrets.nix
    ./ssh.nix
    ./sudo.nix
    ./sway.nix
    ./user.nix
    ./virtualisation.nix
    ./gtk.nix
    ./pam.nix
    ./printing.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}

