{
  networking = {
    hostName = "nixps";
    hostId = "5e13b1e5";
    networkmanager.enable = true;
  };

  # persist connections through rollbacks
  environment.etc."NetworkManager/system-connections" = {
    source = "/persist/etc/NetworkManager/system-connections/";
  };
}
