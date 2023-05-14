{ pkgs, config, lib, ... }:
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
    };

    # persist connections through rollbacks.
    # IMPORTANT: the directory path in 'persist' needs to be created manually. On
    # a fresh system it is missing, which means the symlink will be broken and
    # network manager will not be able to connect to new devices
    environment.etc."NetworkManager/system-connections" = {
      source = "/persist/etc/NetworkManager/system-connections/";
    };
  };
}
