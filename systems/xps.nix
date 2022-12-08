{ config, pkgs, ... }:

{
  imports =
    [
      ./xps-hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-d56d472b-f8c3-40d1-b477-5093c2de5a31".device = "/dev/disk/by-uuid/d56d472b-f8c3-40d1-b477-5093c2de5a31";
  boot.initrd.luks.devices."luks-d56d472b-f8c3-40d1-b477-5093c2de5a31".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixps";

  networking.networkmanager.enable = true;

  services.mullvad-vpn.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.utf8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.utf8";
    LC_IDENTIFICATION = "de_DE.utf8";
    LC_MEASUREMENT = "de_DE.utf8";
    LC_MONETARY = "de_DE.utf8";
    LC_NAME = "de_DE.utf8";
    LC_NUMERIC = "de_DE.utf8";
    LC_PAPER = "de_DE.utf8";
    LC_TELEPHONE = "de_DE.utf8";
    LC_TIME = "de_DE.utf8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jgero = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Johannes";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # NixOs wiki guide: https://nixos.wiki/wiki/Yubikey
  # command for setting up slot 2 on yubikey: https://developers.yubico.com/yubico-pam/Authentication_Using_Challenge-Response.html
  security.pam.yubico = {
    enable = true;
    # debug = true;
    mode = "challenge-response";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    wireguard-tools
    mullvad
    restic
    ntfs3g
  ];

  programs.dconf.enable = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  system.stateVersion = "22.05";
}

