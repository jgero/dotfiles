{ config, lib, ... }:
with lib;
let
  cfg = config.jgero.packages;
in
{
  options.jgero.packages = {
    system = mkOption {
      type = types.listOf types.package;
      description = "additional packages to install on the system level";
      default = [ ];
    };
    home = mkOption {
      type = types.listOf types.package;
      description = "additional packages to install through home manager";
      default = [ ];
    };
  };
  config = {
    environment.systemPackages = cfg.system;
  };
}
