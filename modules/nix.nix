{ pkgs, ... }: {
  nix = {
    settings = {
      allowed-users = [ "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    # enable flakes
    package = pkgs.nixFlakes;
    # automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
