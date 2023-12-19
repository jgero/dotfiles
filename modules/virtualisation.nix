{
  programs.fuse.userAllowOther = true;
  programs.virt-manager.enable = true;

  virtualisation = {
    spiceUSBRedirection.enable = true;
    podman.enable = true;
    libvirtd.enable = true;
  };
}
