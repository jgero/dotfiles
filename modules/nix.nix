{ pkgs, ... }:
let nixPath = "/etc/nixPath";
in {
  systemd.tmpfiles.rules = [
    "L+ ${nixPath} - - - - ${pkgs.path}"
  ];
  nix = {
    nixPath = [ "nixpkgs=${nixPath}" ];
    settings = {
      allowed-users = [ "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
