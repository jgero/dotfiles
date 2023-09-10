{
  programs.fuse.userAllowOther = true;
  virtualisation = {
    podman.enable = true;
    containers.storage.settings = {
      storage = {
        driver = "btrfs";
        graphroot = "/var/lib/containers/storage";
        runroot = "/run/containers/storage";
      };
    };
  };
}
