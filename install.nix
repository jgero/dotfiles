{ pkgs }: pkgs.writeShellApplication {
  name = "install";
  text = ''
    set -eo pipefail

    if [[ -z "$1" ]] || [[ -z "$2" ]]; then
        echo "usage: install <disk-name> <hostname>"
        exit 1
    else
        HOSTNAME="$2"
    fi

    if [ "$1" = nvme0n1 ]; then
        DISK="/dev/nvme0n1"
        PARTITION="/dev/nvme0n1p"
    elif [ "$1" = sda ]; then
        DISK="/dev/sda"
        PARTITION="$DISK"
    else
        echo "expected 'nvme0n1' or 'sda' as disk names"
        exit 1
    fi

    # create new table
    parted --script "$DISK" -- mklabel gpt

    # 0% automatically offsets for optimal performance
    parted --script "$DISK" -- mkpart ESP fat32 0% 512MB
    parted --script "$DISK" -- set 1 esp on

    # make some swap
    parted --script "$DISK" -- mkpart primary linux-swap 512MB 20GB

    # main BTRFS partition
    parted --script "$DISK" -- mkpart primary 20GB 100%

    # create BTRFS with all subvolumes
    mkfs.btrfs -f -L ROOT "$PARTITION"3
    mount -t btrfs "$PARTITION"3 /mnt
    btrfs subvolume create /mnt/root
    btrfs subvolume create /mnt/log
    btrfs subvolume create /mnt/nix
    btrfs subvolume create /mnt/data

    # take empty root snapshot
    btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

    # mount root subvolume as root
    umount /mnt
    mount -o subvol=root,compress=zstd,noatime "$PARTITION"3 /mnt
    
    # nix subvolume with impermanence directory structure
    mkdir /mnt/nix
    mount -o subvol=nix,compress=zstd,noatime "$PARTITION"3 /mnt/nix
    mkdir -p /mnt/nix/persist/etc/NetworkManager/system-connections
    cp /etc/machine-id /mnt/nix/persist/etc/machine-id
    mkdir -p /mnt/nix/persist/etc/ssh
    ssh-keygen -f /mnt/nix/persist/etc/ssh/ssh_host_ed25519_key -t ed25519 -q -N ""
    mkdir /mnt/nix/persist/jgero
    chown 1000:100 /mnt/nix/persist/jgero

    # data subvolume
    mkdir /mnt/data
    mount -o subvol=data,compress=zstd,noatime "$PARTITION"3 /mnt/data
    mkdir -p /mnt/data/jgero
    chown 1000:100 /mnt/data/jgero

    # log subvolume
    mkdir -p /mnt/var/log
    mount -o subvol=log,compress=zstd,noatime "$PARTITION"3 /mnt/var/log

    # create and mount boot fs
    mkfs.fat -F 32 -n BOOT "$PARTITION"1
    mkdir /mnt/boot
    mount "$PARTITION"1 /mnt/boot

    # create swap
    mkswap -L SWAP "$PARTITION"2
    swapon "$PARTITION"2

    nixos-install --flake "github:jgero/dotfiles#$HOSTNAME" --no-root-password
  '';
}
