{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.etc."machine-id".source = "/nix/persist/etc/machine-id";

  boot.supportedFilesystems = [
    "ntfs"
  ];
}
