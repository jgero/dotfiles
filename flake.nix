{
  description = "Who needs a working system anyways, me smash state";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    hyprland.url = "github:hyprwm/Hyprland";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, hyprland, agenix, ... }:
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
            agenix.nixosModules.default
            {
              _module.args.agenix = agenix.packages.x86_64-linux.default;
            }
            nixos-hardware.nixosModules.dell-xps-13-7390
            ./modules
            {
              jgero.network = {
                hostname = "nixps";
                hostid = "5e13b1e5";
              };
              jgero.backup.enable = true;
              jgero.hyprland.enable = true;
            }
            ./hardware/xps_2020.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jgero = import ./home;
              home-manager.extraSpecialArgs = {
                inherit hyprland;
              };
            }
          ];
        };
        nixpad = lib.nixosSystem {
          inherit system;
          modules = [
            hyprland.nixosModules.default
            ./modules
            {
              jgero.network = {
                hostname = "nixpad";
                hostid = "9a102409";
              };
              jgero.hyprland.enable = true;
            }
            ./hardware/thinkpad_2023.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jgero = import ./home;
              home-manager.extraSpecialArgs = {
                inherit hyprland;
              };
            }
          ];
        };
      };
    };
}
