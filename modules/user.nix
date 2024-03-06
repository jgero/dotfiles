{ lib, pkgs, config, ... }:
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
      extraGroups = [
        "wheel"
        "libvirtd"
        (mkIf (config.jgero.virt.dockerCompat) "podman")
      ];
      initialPassword = "password";
    };
  };
}
