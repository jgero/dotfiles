{
  programs.fuse.userAllowOther = true;
  virtualisation = {
    podman.enable = true;
    containers.storage.settings = {
      storage = {
        driver = "overlay";
        graphroot = "/nix/persist/jgero/containers/graph";
        runroot = "/nix/persist/jgero/containers/run";
      };
    };
  };
}
