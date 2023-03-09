# Dotfiles

Use [GNU stow](https://www.gnu.org/software/stow/) to create the symlinks for
all the configurations and even the systemd units.

## Setup

- create symlinks with stow
- create missing `.env` files in systemd directory with contents of this
  structure:
```
RESTIC_PASSWORD="my-secret"
RESTIC_REPOSITORY="my-path"
```
- enable systemd timers and backup to harddrive service (don't forget using
  `--user`)
- `chmod +x bash/.local/bin/*` to make scripts executable

## Cheatsheet

- use `pdfgrep` to find strings in PDF files

