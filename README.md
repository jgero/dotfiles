# Nix dotfiles

I am very new to this so copying this is not (yet) advised.

This repo contains a flake for different hosts. One of them is my private notebook (nixps), the
other one is for using it at work in WSL (wsl). 

## Setup

Clone this repository somewhere on your system and run
`sudo nixos-rebuild switch --flake '.#nixps' --impure`.

> The "switch" argument builds the flake, activates the new generation and creates a new boot entry
> for it, which will directly be the default. Use this when you're sure the configuration works as
> intended. Otherwise while developing using "test" may be the better alternative. It builds the
> generation and swaps to it, but does not do the boot stuff, which means a reboot will result using
> the previous version. It may require a fresh login to correctly load things like desktop icons.

> The `--flake '.#nixps'` tells nix to take the flake in the current directory and use the `nixps`
> configuration.

> `--impure` is needed because nixos-hardware is used. I'm not sure if that is expected or if I'm
> just using an unclean solution.

### SSH keys

SSH keys have to be generated manually. Which keys are expected to be there can be seen in
`home/ssh.nix`.

