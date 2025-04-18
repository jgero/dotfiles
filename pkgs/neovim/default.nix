{ system, nixpkgs }:
let
  pkgs = import nixpkgs { inherit system; };

  myNeovimBuilder = import ./lib/buildNeovimDerivation.nix { inherit pkgs; };
  pluginPartials = import ./partials { inherit pkgs; };
  myNeovim = myNeovimBuilder pluginPartials;
in
myNeovim

#     flake-utils.lib.eachDefaultSystem (system:
#       let
#         pkgs = import nixpkgs { inherit system; };
#         treefmtEval = treefmt-nix.lib.evalModule pkgs ./lib/treefmt.nix;
#
#         myNeovimBuilder = import ./lib/buildNeovimDerivation.nix { inherit pkgs; };
#         pluginPartials = import ./partials { inherit pkgs; };
#         myNeovim = myNeovimBuilder pluginPartials;
#       in
#       {
#         formatter = treefmtEval.config.build.wrapper;
#         checks.formatter = treefmtEval.config.build.check self;
#         packages.default = myNeovim;
#         apps.default = {
#           type = "app";
#           program = "${myNeovim}/bin/nvim";
#         };
#       });
# }
