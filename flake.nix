{
  description = "Who needs a working system anyways, me smash state";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , agenix
    , treefmt-nix
    , impermanence
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      formatter.${system} = treefmtEval.config.build.wrapper;
      checks.${system}.formatter = treefmtEval.config.build.check self;
      packages."${system}".install = import ./install.nix { inherit pkgs; };
      nixosConfigurations = builtins.listToAttrs (
        builtins.map
          (host: {
            name = host.name;
            value = lib.nixosSystem {
              inherit system pkgs;
              modules = [
                impermanence.nixosModules.impermanence
                agenix.nixosModules.default
                {
                  _module.args.agenix = agenix.packages.${system}.default;
                }
                ./modules
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.jgero = import ./home;
                  home-manager.extraSpecialArgs = {
                    inherit impermanence;
                  };
                }
              ] ++ host.nixosModules;
            };
          })
          (import ./hosts.nix { inherit nixos-hardware; }));
    };
}
