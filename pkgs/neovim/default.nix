{ nixpkgs-unstable, flake-utils, ... }:
flake-utils.lib.eachDefaultSystem (system:
let
  pkgs = import nixpkgs-unstable { inherit system; };

  myNeovimBuilder = import ./lib/buildNeovimDerivation.nix { inherit pkgs; };
  pluginPartials = import ./partials { inherit pkgs; lib = nixpkgs-unstable.lib; };
  myNeovim = myNeovimBuilder pluginPartials;
in
{
  packages.neovim = myNeovim;
  apps.neovim = {
    type = "app";
    program = "${myNeovim}/bin/nvim";
  };
})
