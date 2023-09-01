{ config, lib, ... }:
with lib;
let
  cfg = config.jgero.network;
in
{
  options.jgero.network = {
    hostname = mkOption {
      type = types.str;
    };
    hostid = mkOption {
      type = types.str;
      description = "output of head -c 8 /etc/machine-id";
    };
  };
  config = {
    networking = {
      hostName = cfg.hostname;
      hostId = cfg.hostid;
      networkmanager.enable = true;
      firewall.enable = true;
    };
  };
}
