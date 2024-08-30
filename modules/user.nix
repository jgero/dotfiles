{ lib, pkgs, config, ... }:
with lib;
{
  options.jgero.user = {
    email = mkOption {
      type = types.str;
    };
  };
  config = {
    programs.zsh.enable = true;
    users.users.jgero = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups = lib.lists.flatten [
        "wheel"
        "networkmanager"
        "libvirtd"
        "lp"
      ] ++ lib.lists.optional (config.jgero.virt.dockerCompat) "podman";
      initialPassword = "password";
    };
  };
}
