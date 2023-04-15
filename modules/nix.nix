{ pkgs, ... }: {
  nix = {
    # enable flakes
    package = pkgs.nixFlakes;
    settings.experimental-features = [ "nix-command" "flakes" ];
    # automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
