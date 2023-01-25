# Dotfiles

Use [GNU stow](https://www.gnu.org/software/stow/) to create the symlinks for
all the configurations and even the systemd units.

## Setup

- create symlinks with stow (TODO: more details)
- create missing `.env` files in systemd directory with contents of this
  structure:
```
RESTIC_PASSWORD="my-secret"
RESTIC_REPOSITORY="my-path"
```
- enable systemd timers and backup to harddrive service (don't forget using
  `--user`
- `chmod +x bash/scripts/*` to make scripts executable

