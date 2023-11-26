{
  programs.fuse.userAllowOther = true;
  programs.virt-manager.enable = true;

  virtualisation = {
    spiceUSBRedirection.enable = true;
    podman.enable = true;
    libvirtd.enable = true;
    containers.storage.settings = {
      storage = {
        driver = "overlay";
        graphroot = "/nix/persist/jgero/containers/graph";
        runroot = "/nix/persist/jgero/containers/run";
      };
    };
  };
}
