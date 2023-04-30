{
  description = "Who needs a working system anyways, me smash state";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }:
    let
      system = "x84_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      lib = nixpkgs.lib;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      nixosConfigurations = {
        nixps = lib.nixosSystem {
          inherit system;
          modules = [
            nixos-hardware.nixosModules.dell-xps-13-7390
            ./modules
            ./hardware/xps_2020.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jgero = import ./home;
            }
          ];
        };
      };
    };
}
