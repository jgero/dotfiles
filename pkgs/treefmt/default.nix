{ self, flake-utils, treefmt-nix, nixpkgs-unstable, ... }:
flake-utils.lib.eachDefaultSystem (system:
let
  pkgs = import nixpkgs-unstable { inherit system; };
  treefmtEval = treefmt-nix.lib.evalModule pkgs ./config.nix;
in
{
  formatter = treefmtEval.config.build.wrapper;
  checks.formatter = treefmtEval.config.build.check self;
})
