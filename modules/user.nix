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
      extraGroups = lib.lists.flatten [
        "wheel"
        "networkmanager"
        "libvirtd"
      ] ++ lib.lists.optional (config.jgero.virt.dockerCompat) "podman";
      initialPassword = "password";
    };
  };
}
