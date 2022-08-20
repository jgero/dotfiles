# Nix dotfiles

I am very new to this so copying this is not (yet) advised.

## Setup

Clone this repository somewhere on your machine and link the configuration and hardware
configuration into `/etc/nixos/`. I do not know if it is necessary but I changed the owner of the
symlink files to root.

```bash
sudo ln -sf ~/git/dotfiles/configuration.nix /etc/nixos
sudo ln -sf ~/git/dotfiles/hardware-configuration.nix /etc/nixos
sudo chown -hR /etc/nixos
```

### SSH keys

SSH keys also have to be set up manually. Which keys are expected to be there can be seen in
`home/ssh.nix`.

