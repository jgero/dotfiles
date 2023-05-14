{
  networking = {
    hostName = "nixps";
    hostId = "5e13b1e5";
    networkmanager.enable = true;
  };

  # persist connections through rollbacks.
  # IMPORTANT: the directory path in 'persist' needs to be created manually. On
  # a fresh system it is missing, which means the symlink will be broken and
  # network manager will not be able to connect to new devices
  environment.etc."NetworkManager/system-connections" = {
    source = "/persist/etc/NetworkManager/system-connections/";
  };
}
