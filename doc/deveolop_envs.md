# Development environments with nix

Setting up development environments for nix is easy and there are different
approaches to do this with `nix-shell` or flakes [^1]. But both strategies have
the problem that their outputs are not registered as a garbage collector root
and thus will be cleaned up [^2].

Fortunately `nix develop` [^3] allows providing a profile to which the
environment should be persisted to: `nix develop --profile /path/to/profile`.
This profile will then automatically be registered as garbage collector root and
stop it form being cleaned up. It can be loaded again with `nix develop
/path/to/profile/`.

To make this process less verbose I included some convenience scripts to
automate creating and loading these profiles.

[^1]: [Flakes](https://nixos.wiki/wiki/Flakes)
[^2]: [Garbage collection](https://nixos.org/manual/nix/stable/package-management/garbage-collection.html)
[^3]: [Nix develop](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop.html)
