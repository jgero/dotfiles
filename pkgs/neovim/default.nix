{ nixpkgs, nixpkgs-unstable, flake-utils, ... }:
flake-utils.lib.eachDefaultSystem (system:
let
  pkgs = import nixpkgs { inherit system; };
  pkgs-unstable = import nixpkgs-unstable { inherit system; };

  myNeovimBuilder = import ./lib/buildNeovimDerivation.nix { inherit pkgs; };
  pluginPartials = import ./partials { inherit pkgs pkgs-unstable; lib = nixpkgs.lib; };
  myNeovim = myNeovimBuilder pluginPartials;
in
{
  packages.neovim = myNeovim;
  apps.neovim = {
    type = "app";
    program = "${myNeovim}/bin/nvim";
  };
})
