# Nix setup with temporary root fs

TLDR; I split the file system into multiple parts and only selectively persist
data. This is achieved by using a file system that supports snapshotting and
rolling back to an empty snapshot on every boot.

The starting point is the [minimal NixOS ISO
image](https://nixos.org/download.html).

## Partitioning the disk

> A basic GPT table with EFI, swap for hibernation and a root file system
> partitions suffice, nothing special necessary.

Before starting we need to find out to which disk the system should be installed
to. Tools to show disks and partitions like `lsblk` can be used for that.

Then the new GPT partition table can be created, `gdisk` is a useful tool for
that. Use `sudo gdisk /dev/...` to start partitioning the disk where the system
is supposed to be installed on. Following partitions need to be created:

1. 512 MiB EFI partition (ef00)
   > Sometimes people use even more, I don't know how much is necessary
2. 20 GiB swap (8200)
   > Needs to be at least as big as the RAM of the device to be able to
   > hibernate, but a bit more shouldn't hurt
3. All remaining space for the linux root filesystem (8303)

## Creating the file systems

> ZFS datasets are used to split the root partition into smaller parts, for more
> fine grained control. Most importantly before installing anything the empty
> snapshot has to be taken. Boot and swap partitions are done the standard way
> with vfat and linux swap.

Storing the disk name in an environment variable is very convenient:
`DISK=/dev/vda`. First the ZFS file system has to be crated and mounted, since
the boot partition has to be mounted inside the ZFS file system later.

ZFS uses pools, which group disks and partitions into logical storage containers
as means to manage storage space. My hardware doesn't have multiple disks so I
just use one disk as the pool. [The OpenZFS
wiki](https://openzfs.github.io/openzfs-docs/Getting%20Started/NixOS/Root%20on%20ZFS/2-system-installation.html)
is really helpful for finding examples to set up different pool configurations.
In my case this is:

```
zpool create \
    -o ashift=12 \
    -o autotrim=on \
    -R /mnt \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=zstd \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -O mountpoint=/ \
    rpool \
    "$DISK"3
```

On its own the pool cannot be mounted yet, ZFS has datasets for that. Here the
decision where in the file system state is kept happens, so I split it up into
root, nix, home, persist and log datasets to differentiate. Sate I want to keep
is in `rpool/safe` datasets, state I want to get rid of is in `rpool/local`. The
`/nix` directory is managed by the package manager anyways, so no special
handling is necessary here. But since I also want to get rid of state in the
root partition an empty snapshot is necessary to be able to roll back to it on
boot and clean this dataset up. So to create the datasets and create the
snapshot run:

```
zfs create -p -o mountpoint=legacy rpool/local/root
zfs snapshot rpool/local/root@blank
mount -t zfs rpool/local/root /mnt
zfs create -p -o mountpoint=legacy rpool/local/nix
mount -t zfs rpool/local/nix /mnt/nix
zfs create -p -o mountpoint=legacy rpool/safe/home
mount -t zfs rpool/safe/home /mnt/home
zfs create -p -o mountpoint=legacy rpool/safe/persist
mount -t zfs rpool/safe/persist /mnt/persist
zfs create -p -o mountpoint=legacy rpool/safe/log
mount -t zfs rpool/safe/log /mnt/var/log
```

> It may be necessary to create missing directories before mounting

Earlier the creation of the boot file system and the swap was skipped so that
has to be done now. Nothing interesting is necessary for the boot partition:

```
mkfs.vfat "$DISK"1
mount "$DISK"1 /mnt/boot
```

> Here also missing directories need to be created

And setup of swap:

```
mkswap "$DISK"2
swapon "$DISK"2
```

## Initial NixOS install

NixOS comes with a set of tools to ease the initial installation of the OS. One
of them is `nixos-generate-config` to extract an initial configuration from the
system and write it to the default location in
`/etc/nixos/configuration.nix`. Since during the
installation the 'root' is mounted to `/mnt` the exact command to generate the
configuration is:

```
nixos-generate-config --root /mnt
```

Before installing, some modifications of the generated configurations in the
mounted root have to be made.

### Settings for ZFS

First of all ZFS needs the networking host id to be set [^3]. While already at
it networking should also be enabled and host name set.

```nix
networking = {
    hostName = "nixps";
    hostId = "12341234";
    networkmanager.enable = true;
};
```

Then have a look at the `hardware-configuration.nix` and check if the datasets
are mounted to the correct file systems.

> Depending on the naming of the datasets, the `nixos-generate-config` tool may
> get confused when the dataset device names multiple '/' in them. Unwanted
> dataset mounts should be deleted.

Additionally add the `neededForBoot = true;` option has to be set in the
`/var/log` file system. Otherwise logs during boot may be lost.

When just using the generated configuration with a vfat boot partition NixOS has
trouble finding the ZFS pool on boot [^4]. To fix that I have to tell the OS
where to find the devices it is supposed to mount on boot:

```nix
boot.zfs.devNodes = "/dev/disk/by-partuuid";
```

### Create user

A proper system also needs a non-root user. Since I messed up setting the
initial passwords with `passwd` multiple times I use the nix configuration way
to set it.

```nix
users.users.jgero = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "password";
};
```

### Final steps

This is the time to add a useful editor to the system packages, as well as tools
like git and curl which may be necessary to further configure the system once it
is installed. For information about what further options are available have a
look at the [NixOS options search](https://search.nixos.org/options?).

Now everything is prepared for running the actual installation:

```
sudo nixos-install
```

> While installing you will be prompted to set a password. After the
> installation is done `reboot`

## Flake configuration

> Using a flake for the  system configuration is not necessary, but moving it
> out of the `/etc/nixos` directory is. The step after this is setting up the
> rollback of the root file system on boot, which would also get rid of the
> system configuration if left at its default location.

Nix flakes are still an experimental feature at the time of writing. To enable
support of flakes the nix package has to be set to the latest version which
supports flakes, and also enabling the experimental feature:

```nix
nix.package = pkgs.nixFlakes;
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

> `sudo nixos-rebuild switch` to apply these configuration changes

To not lose the configuration during reboot once the rollback on boot is set up
it has to be moved to a location which is not affected by the rollback. I use
`/home/jgero/projects/dotfiles` and also change the ownership to the non-root
user.

```
mkdir -p /home/jgero/projects/dotfiles
sudo mv /etc/nixos/* /home/jgero/projects/dotfiles
sudo chown jgero:users /home/jgero/projects/dotfiles/*
```

Next, an empty flake can be generated in the dotfiles directory to start moving
the configuration to a flake.

```
nix flake init
```

The generated `flake.nix` file is basically empty. To create the system
configuration some additions are necessary. For a more stable experience I use
the stable channel for the nixpkgs with the matching home-manger release
channel.

> Home-manager is definitely not necessary and could be skipped, but I like
> simpler configurations and that's why I chose a setup with home-manager baked
> into the system flake

When using flakes, the nixpkgs and home-manager channels can be defined in the
`inputs` section of the flake, along with syncing up the packages they use. This
also avoids the process or adding the home-manager channel via commandline you
normally have to do when using home-manager with a normal `configuration.nix`.

```nix
inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
};
```

For the outputs I use a 'let..in' block for pre-configuration before the main
config:

```nix
outputs = { nixpkgs, home-manager, ... }:
let
    system = "x84_64-linux";
    pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;
in {
    # ...
};
```

Inside the 'let...in' block the system configuration, wrapped in a `nixosSystem`
function, needs to happen. To keep the `flake.nix` at a reasonable size the
`configuration.nix` system configuration and the `home.nix` home configurations
are imported as modules. With this setup the home-manager flake is integrated
into the system flake, which means the home-manager configuration is
automatically built when building the system flake [^5]. There are other ways to
integrate home-manager to split the system configuration from the home
configuration, refer to the [home-manager
documentation](https://nix-community.github.io/home-manager/index.html) for
that.

```nix
nixosConfigurations = {
    nixps = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jgero = import ./home.nix
          }
        ];
    };
};
```

As you can see this configuration snippet refers to a `home.nix` file. The fist
few options define which version is used and information about the user which is
supposed to be configured. It also allows home-manager to manage itself by
enabling it as a program. These settings are part of the minimal configuration
options [^6]. The settings which follow the home-manager setup options are
configurations for actual programs for the user. There is a [search for all the
possible home-manager
options](https://mipmip.github.io/home-manager-option-search/), similar to the
NixOS option search.

```nix
{ config, pkgs, ... }:
{
    home.stateVersion = "22.11";
    programs.home-manger.enable = true;
    home.username = "jgero";
    home.homeDirectory = "/home/jgero";

    programs.git.enable = true;
}
```

Now the flake should be ready to be built and switched to. Use `nixos-rebuild
build --flake .#` to build the configuration. If the hostname of the system
differs from the name used in the `nixosConfigurations` block use '.#nixps' or
whatever you used inside the configuration instead of '.#'. If the build is
successful and you are ready to switch to the new configuration use `sudo
nixos-rebuild switch --flake .#`.

Reboot to verify the system is still functional.

## Setting up the rollback on boot

The last step for the temporary root file system is to to the rollback on boot.
With ZFS this is very easy and can be done with a single command, executed once
the devices are available while booting [^1]. Just add this to the
`hardware-configuration.nix`:

```nix
boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r rpool/local/root@blank
'';
```

Reboot again. If it worked you should see the sudo lecture again when using it,
just like on a completely fresh system. Commands like `tree -x /` and `zfs diff
rpool/local/root@blank` can help understand what will be lost on reboot.

> TODO: provide different examples what ways nix offers to do that. The 'etc'
> and 'systemd.tempfiles.rules' options may be useful [^1].

## Finishing touches

The last step to make the system usable is to add a window manager or a desktop
environment to run graphical user interfaces. These packages can be installed
for the user by adding them to the `home.packages` in the home-manager
configuration.

```nix
home.packages = with pkgs; [
  firefox
];
```

Installing a desktop environment needs a few more settings, but it's still
pretty easy, the nix wiki has really good examples like for example for
[GNOME](https://nixos.wiki/wiki/GNOME).

```nix
services.xserver.enable = true;
services.xserver.displayManager.gdm.enable = true;
services.xserver.desktopManager.gnome.enable = true;
programs.dconf.enable = true;

environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour
  gnome-console
  xterm
]) ++ (with pkgs.gnome; [
  cheese
  gnome-music
  gnome-maps
  gnome-terminal
  epiphany
  geary
  gnome-characters
  gnome-weather
  gnome-contacts
]);
```

[^1]: [Erase you darlings - immutable infrastructure for mutable systems](https://grahamc.com/blog/erase-your-darlings/)
[^2]: [Install home-manager](https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module)
[^3]: [NixOs networking.hostId](https://nixos.org/manual/nixos/stable/options.html#opt-networking.hostId)
[^4]: [Zfs on NixOs cannot import pool](https://discourse.nixos.org/t/cannot-import-zfs-pool-at-boot/4805/18)
[^5]: [Home-manager as NixOS module](https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module)
[^6]: [Home-manager minimal configuration](https://nix-community.github.io/home-manager/index.html#sec-usage-configuration)

