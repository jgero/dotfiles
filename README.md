# Dotfiles

System flake for my Dell XPS.

For a truly reproducible system, and to avoid as much potentially unexpected
state as possible, this configuration emulates a temporary root file system by
wiping the root partition on boot via rollback to an empty snapshot with ZFS.

> Such a setup is possible because NixOS only needs `/boot` and `/nix` in order
> to boot, all other system files are simply links to files in `/nix`. [^1]

To make it less annoying to use the system, the state of the home directory is
kept (for now). For more information on how to set up the partitions to be able
to use the flake see [this write-up](doc/nix_setup.md). Because of obvious
reasons the recommended wallpaper for this setup is
[this](https://github.com/krebs/nix-anarchy).

## Maintenance

Upgrading the system is done by updating the nix flake. Also remember to look
for firmware update with `fwupdmgr`.

## Considerations for the future

### Differing configurations

If for some reason I should need different configurations on different systems I
should consider building the whole flake in a functional style. Then I could
just set some options for different host names in the `flake.nix` file.
[Here](https://jdisaacs.com/blog/nixos-config/) is an example of how that could
be done.

[^1]: [NixOS Wiki - Impermanence](https://nixos.wiki/wiki/Impermanence)

