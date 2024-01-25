# Dotfiles

```
sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake github:jgero/dotfiles#nixpad
sudo nixos-install --flake github:jgero/dotfiles#nixpad --root /mnt
```

## TODO

- Implement [append only
backups](https://ruderich.org/simon/notes/append-only-backups-with-restic-and-rclone)

[^1]: [NixOS Wiki - Impermanence](https://nixos.wiki/wiki/Impermanence)

