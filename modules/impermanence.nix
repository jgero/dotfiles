let
  impermanence = builtins.fetchTarball {
    url = "https://github.com/nix-community/impermanence/archive/master.tar.gz";
    sha256 = "095q3c1kyj7lpnn1i53c0158jh02avsm6xmkvql045xppkxfnk1b";
  };
in
{
  imports = [ "${impermanence}/nixos.nix" ];
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/bluetooth"
    ];
  };
}
