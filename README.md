# Dotfiles

System flake for my systems.

For a truly reproducible system, and to avoid as much potentially unexpected
state as possible, this configuration emulates a temporary root file system by
wiping the root partition on boot via rollback to an empty snapshot with ZFS.

> Such a setup is possible because NixOS only needs `/boot` and `/nix` in order
> to boot, all other system files are simply links to files in `/nix`. [^1]

To make it less annoying to use the system, the state of the home directory is
kept (for now). For more information on how to set up the partitions to be able
to use the flake see [this write-up](doc/nix_setup.md). Because of obvious
reasons the recommended wallpaper or sticker for this setup is
[this](https://github.com/krebs/nix-anarchy).

## Usage hints

Hyprland is an awesome compositor, but it crashes when disabling or unplugging a
screen while in mirroring mode, so be careful when using the display
keybindings and use the screen extension mode when unplugging stuff to be sure.

## Maintenance

Upgrading the system is done by updating the nix flake. Also remember to look
for firmware update with `fwupdmgr`.

## Multiple machines

I use multiple laptops with almost the same configuration. The problem here is
the *almost*. To allow these small differences some of the modules are hidden
behind their own options, like backups and networking. But most of the
configuration is just considered default for my systems and applied without
explicit enabling.

[^1]: [NixOS Wiki - Impermanence](https://nixos.wiki/wiki/Impermanence)

