{ config, lib, ... }:
with lib;
let
  cfg = config.jgero.virt;
in
{
  options.jgero.virt = {
    dockerCompat = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = {
    programs.fuse.userAllowOther = true;
    programs.virt-manager.enable = true;

    # cross compile with QEMU binfmt
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    virtualisation = {
      spiceUSBRedirection.enable = true;
      podman = { enable = true; } // optionalAttrs cfg.dockerCompat
        {
          dockerCompat = true;
          dockerSocket.enable = true;
        };
      libvirtd.enable = true;
    };
  };
}
