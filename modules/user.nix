{ lib, ... }:
with lib;
{
  options.jgero.user = {
    email = mkOption {
      type = types.str;
    };
  };
  config = {
    users.users.jgero = {
      shell = pkgs.bash;
      isNormalUser = true;
      extraGroups = [ "wheel" "libvirtd" ];
      initialPassword = "password";
    };
  };
}
